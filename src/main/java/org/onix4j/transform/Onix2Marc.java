package org.onix4j.transform;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamSource;

/**
 * Created by IntelliJ IDEA.
 * User: Neta
 * Date: 5/19/14
 *
 * This class is a utility
 */
public class Onix2Marc {

    private static String xsltFileName = "onix2marc.xsl";

    public static void transform(String fileName, Source xmlInput, Result output) throws TransformerException {
        Source xsl = new StreamSource(Onix2Marc.class.getClassLoader().getResourceAsStream(xsltFileName));

        Transformer transformer = TransformerFactory.newInstance().newTransformer(xsl);
        transformer.setParameter("filename", fileName);
        transformer.transform(xmlInput, output);
    }
}
