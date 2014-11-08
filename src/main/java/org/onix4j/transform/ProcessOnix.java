package org.onix4j.transform;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.converters.collections.CollectionConverter;
import com.thoughtworks.xstream.io.StreamException;
import com.thoughtworks.xstream.io.xml.StaxDriver;
import com.thoughtworks.xstream.mapper.ClassAliasingMapper;
import org.apache.log4j.Logger;
import org.onix4j.exporter.LogExporter;
import org.onix4j.metadata.Column;
import org.onix4j.model.BasicProduct;
import org.onix4j.model.Onix;
import org.onix4j.model.OnixMetadata;
import org.onix4j.model.OnixProduct;
import org.onix4j.util.FileUtils;
import org.onix4j.util.ReflectionUtils;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: Neta
 * Date: 5/20/14
 * Time: 12:37 PM
 */
public class ProcessOnix {
    private static Map<Class<? extends OnixProduct>, String> xsltFiles;
    static {
        xsltFiles = new HashMap<Class<? extends OnixProduct>, String>();
        xsltFiles.put(BasicProduct.class, "onix2basicProduct.xsl");
    }

    private static XStream xstream = new XStream(new StaxDriver());
    private static List<Class> mappedClasses = new ArrayList<Class>();
    private static Class<? extends OnixProduct> currentClass;
    private static Logger logger = Logger.getLogger(ProcessOnix.class);

    private static <T extends OnixProduct> void init(Class<T> clz) {
        if (currentClass == clz)  {
            // There is no way to remove the implicit collection property, so when using multiple Product classes -
            // the stream should be re-created (in case the product class changed)
            return;
        }
        currentClass = clz;
        xstream = new XStream(new StaxDriver());
        xstream.alias("onix", Onix.class);

        xstream.addImplicitCollection(Onix.class, "products", clz);

        recursivelyMapProduct(clz);
    }

    private static <T extends OnixProduct> void recursivelyMapProduct(final Class<T> clz) {
        if (mappedClasses.contains(clz)) {
            return;
        }

        mappedClasses.add(clz);

        xstream.alias(getXStreamAlias(clz), clz);

        final ClassAliasingMapper mapper = new ClassAliasingMapper(xstream.getMapper());

        final ReflectionUtils.FieldCallback fc = new ReflectionUtils.FieldCallback() {
            public void doWith(Field field) throws IllegalArgumentException, IllegalAccessException {
                if (field.getType().isAssignableFrom(List.class)) {


                    // Cannot use this for multiple list fields in product
                    // xstream.addImplicitCollection(BasicProduct.class, field.getName(), clz);
                    // instead we use:

                    final Column annotation = field.getAnnotation(Column.class);
                    String singleElementName;
                    if (annotation != null && annotation.elementName() != null && !annotation.elementName().isEmpty()) {
                        singleElementName = annotation.elementName();
                    } else {
                        singleElementName = field.getName().substring(0, field.getName().length() - 1); // remove the s from the end for the name
                    }

                    Class<?> genericListClz = ReflectionUtils.getListGenericType(field);
                    mapper.addClassAlias(singleElementName, genericListClz);
                    xstream.registerLocalConverter(clz, field.getName(), new CollectionConverter(mapper));

                    final String thisPackageName = this.getClass().getPackage().getName();
                    if (genericListClz.getCanonicalName().startsWith(thisPackageName.substring(0,thisPackageName.lastIndexOf(".")))) {
                        if (OnixProduct.class.isAssignableFrom(genericListClz)) {
                            recursivelyMapProduct(genericListClz.asSubclass(OnixProduct.class));
                        }
                    }
                }
            }
        };

        ReflectionUtils.doWithFields(clz, fc, null);

    }

    private static <T extends OnixProduct> String getXStreamAlias(Class<T> clz) {
        XStreamAlias alias = clz.getAnnotation(XStreamAlias.class);
        if (alias != null && alias.value() != null && !alias.value().isEmpty())  {
            return alias.value();
        }
        return clz.getCanonicalName();
    }

    public static <T extends OnixProduct> void transformOnix2BasicProductsXML(Class<T> clz, Source xmlInput, Result output) throws TransformerException {
        Source xsl = new StreamSource(Onix2Marc.class.getClassLoader().getResourceAsStream(xsltFiles.get(clz)));

        Transformer transformer = TransformerFactory.newInstance().newTransformer(xsl);
        transformer.transform(xmlInput, output);
    }

    public static String basicProduct2XML(Onix onix) {
        return xstream.toXML(onix);
    }

    @SuppressWarnings("unchecked")
    public static <T extends OnixProduct> Onix<T> XML2BasicProduct(Class<T> clz, String xml) {
        init(clz);
        return (Onix<T>)xstream.fromXML(xml);
    }

    public static void main(String args[]) throws IOException
        {
        String onixDirectory;
        if (args.length < 1) {
            System.out.println("Usage: java -cp onix4j.jar BasicProduct2XML onix.xml [output_directory]");
            System.out.println("       java -cp onix4j.jar BasicProduct2XML onix_directory [output_directory]");
            return;
        } else {
            onixDirectory = args[0];
        }

        String outDirectory;
        if ( args.length < 2) {
            outDirectory = onixDirectory;
        } else {
            outDirectory = args[1];
        }

        final File onixFile = new File(onixDirectory);
        if (onixFile.isDirectory()) {
            for (File file : onixFile.listFiles()) {

                if (!file.getName().endsWith("xml") && !file.getName().endsWith("onx") &&
                        !file.getName().endsWith("o4j")) {
                    continue;
                }
                handleSingleFile(file, outDirectory);
            }
        } else {
            handleSingleFile(onixFile, outDirectory);
        }
    }

    private static void handleSingleFile(File file, String outDirectory) {
        logger.info("Processing " + file.getName());
        Source xmlInput = new StreamSource(file);
        final String outFileName = outDirectory + "/" + file.getName() + ".product.xml";
        Result xmlOutput = new StreamResult(new File(outFileName));

        try {
            transformOnix2BasicProductsXML(BasicProduct.class, xmlInput, xmlOutput);

            final Onix<BasicProduct> onix = XML2BasicProduct(BasicProduct.class, FileUtils.readFile(outFileName));
            onix.setMetaData(new OnixMetadata(onix.sentDate, outFileName));
            FileOutputStream output = new FileOutputStream(outDirectory + "/" + file.getName() + ".product.sql");
            output.write(new LogExporter().export(new LogExporter().export(onix, true)).toString().getBytes());
            output.close();
        } catch (TransformerException e) {
            logger.error("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
        } catch (IOException e) {
            logger.error("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
        } catch (StreamException e) {
            logger.error("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
        }
    }
}