package org.onix4j.transform;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.converters.collections.CollectionConverter;
import com.thoughtworks.xstream.io.xml.StaxDriver;
import com.thoughtworks.xstream.mapper.ClassAliasingMapper;
import org.apache.log4j.Logger;
import org.onix4j.metadata.Column;
import org.onix4j.model.Onix;
import org.onix4j.model.OnixMetadata;
import org.onix4j.model.OnixProduct;
import org.onix4j.util.FileUtils;
import org.onix4j.util.ReflectionUtils;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * User: Neta
 * Date: 5/20/14
 * Time: 12:37 PM
 */
public class Onix2BasicProductsXML<T extends OnixProduct> implements Transform<File, Onix<T>> {
    private static final String PRODUCT_TEMP_SUFFIX = ".product.tmp";
    private Map<Class<T>, String> xsltFiles;
    private XStream xstream = new XStream(new StaxDriver());
    private List<Class> mappedClasses = new ArrayList<Class>();
    private Class<T> currentClass;
    private static Logger logger = Logger.getLogger(Onix2BasicProductsXML.class);

    public void init(Class<T> clz) {
        xsltFiles = new HashMap<Class<T>, String>();
        xsltFiles.put(clz, "onix2basicProduct.xsl");
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

    private <T extends OnixProduct> void recursivelyMapProduct(final Class<T> clz) {
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

    public <T extends OnixProduct> void transformOnix2BasicProductsXML(Class<T> clz, Source xmlInput, Result output, File file) throws TransformerException {
        Source xsl = new StreamSource(Onix2Marc.class.getClassLoader().getResourceAsStream(xsltFiles.get(clz)));

        Transformer transformer = TransformerFactory.newInstance().newTransformer(xsl);
        transformer.setParameter("fileName", file.getName());
        SimpleDateFormat dt1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        transformer.setParameter("timestamp", dt1.format(new Date(file.lastModified())));
        transformer.transform(xmlInput, output);
    }

    public String basicProduct2XML(Onix onix) {
        return xstream.toXML(onix);
    }

    @SuppressWarnings("unchecked")
    public Onix<T> XML2BasicProduct(Class<T> clz, String xml) {
        init(clz);
        return (Onix<T>)xstream.fromXML(xml);
    }

    public Onix<T> transform(File file, boolean lazy) {
        if (!file.exists()) {
            return null;
        }
        Source xmlInput = new StreamSource(file);
        final String outFileName = file.getParentFile().getAbsolutePath() + "/" + file.getName() + PRODUCT_TEMP_SUFFIX;

        final File outFile = new File(outFileName);

         try {
             if (!lazy || !outFile.exists())  {
                 Result xmlOutput = new StreamResult(outFile);
                 transformOnix2BasicProductsXML(currentClass, xmlInput, xmlOutput, file);
             }

             final Onix<T> onix = XML2BasicProduct(currentClass, FileUtils.readFile(outFileName));
             onix.setMetaData(new OnixMetadata(onix.sentDate, file.getAbsolutePath()));
             return onix;
         } catch (IOException e) {
            logger.error("Failed to transform file " +  file.getName(), e);
         } catch (TransformerException e) {
            logger.error("Failed to transform file " +  file.getName(), e);
         }
         return null; 
    }
}