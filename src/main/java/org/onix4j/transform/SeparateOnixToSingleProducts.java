package org.onix4j.transform;

import org.apache.log4j.Logger;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamSource;

/**
 * User: Neta
 * Date: 5/24/14
 * Time: 8:26 PM
 */
public class SeparateOnixToSingleProducts {
    private static Logger logger = Logger.getLogger(ProcessOnix.class);

    public static void transform(Source xmlInput, Result xmlOutput) throws TransformerException {
        try {
            Source xsl = new StreamSource(Onix2Marc.class.getClassLoader().getResourceAsStream("onix2separateOnixSingleProducts.xsl"));

            Transformer transformer = TransformerFactory.newInstance().newTransformer(xsl);

            transformer.transform(xmlInput, xmlOutput);
        } catch (TransformerConfigurationException e) {
            logger.error("Failed to transform file", e);
        } catch (TransformerException e) {
            logger.error("Failed to transform file", e);
        }
    }
}
