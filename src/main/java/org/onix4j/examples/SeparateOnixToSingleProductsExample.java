package org.onix4j.examples;

import org.onix4j.transform.SeparateOnixToSingleProducts;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

/**
 * User: Neta
 * Date: 6/27/14
 * Time: 10:55 AM
 */
public class SeparateOnixToSingleProductsExample {
    public static void main(String args[]) throws TransformerException {
         if (args.length < 3) {
            System.err.println("Usage: java -cp onix4j.jar SeparateOnixToSingleProducts onix file out_directory out_suffix");
            return;
         }

        String fileName = args[0];
        String outDirectory = args[1];
        String outSuffix = args[2];

        final File file = new File(fileName);
        Source xmlInput = new StreamSource(file);
        final String outFileName = outDirectory + "/" + file.getName() + outSuffix;

        Result xmlOutput = new StreamResult(new File(outFileName));

        SeparateOnixToSingleProducts.transform(xmlInput, xmlOutput);
    }
}
