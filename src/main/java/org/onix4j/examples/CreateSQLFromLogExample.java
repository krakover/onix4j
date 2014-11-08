package org.onix4j.examples;

import com.thoughtworks.xstream.io.StreamException;
import org.onix4j.exporter.SQLExporter;
import org.onix4j.filter.FileExtensionFilter;
import org.onix4j.filter.Filter;
import org.onix4j.filter.LogFileFilter;
import org.onix4j.model.BasicProduct;
import org.onix4j.model.EnhanceProduct;
import org.onix4j.model.Onix;
import org.onix4j.reader.LogFileOnixInput;
import org.onix4j.transform.Onix2BasicProductsXML;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;

/**
 * User: Neta
 * Date: 6/7/14
 * Time: 10:36 AM
 */
public class CreateSQLFromLogExample {
    public static void main(String args[]) throws IOException {
        String logFileName;
        if (args.length < 1) {
            System.out.println("Usage: java -cp onix4j.jar CreateSQLFromLogExample log_file out_sql_file");
            return;
        } else {
            logFileName = args[0];
        }

        String outFileName;
        if ( args.length < 2) {
            outFileName = logFileName + ".sql";
        } else {
            outFileName = args[1];
        }

        EnhanceProduct.filters = Arrays.asList((Filter) new LogFileFilter(logFileName));
        List<String> fileNames = new LogFileOnixInput(logFileName).getFileNames();

        FileOutputStream output = null;
        try {
            output = new FileOutputStream(outFileName);
            for (String fileName : fileNames) {
                handleSingleFile(output, new File(fileName));
            }
        } finally {
            if (output != null) {
                output.close();
            }
        }
    }

    private static void handleSingleFile(OutputStream output, File file) throws IOException {
        System.out.println("Processing " + file.getName());
        final Onix2BasicProductsXML<BasicProduct> onix2BasicProductsXML = new Onix2BasicProductsXML<BasicProduct>();
        onix2BasicProductsXML.init(BasicProduct.class);
        Onix<BasicProduct> onix = onix2BasicProductsXML.transform(file, true);
        if (new FileExtensionFilter().useOnix(onix)) {
            try {
                output.write(new SQLExporter().export(new SQLExporter().export(onix, true)).getBytes());
            } catch (StreamException e) {
                System.out.println("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
            }
        }
    }
}
