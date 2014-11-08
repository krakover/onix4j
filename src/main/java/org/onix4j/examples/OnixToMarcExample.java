package org.onix4j.examples;

import org.onix4j.filter.FileExtensionFilter;
import org.onix4j.filter.Filter;
import org.onix4j.filter.LogFileFilter;
import org.onix4j.model.EnhanceProduct;
import org.onix4j.model.OnixLog;
import org.onix4j.reader.LogFileOnixInput;
import org.onix4j.reader.SingleDirectoryFileSystemOnixInput;
import org.onix4j.transform.Onix2Marc;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * User: Neta
 * Date: 6/27/14
 * Time: 9:49 AM
 */
public class OnixToMarcExample {
        public static void main(String args[]) throws IOException {
        String onixDirectory;
        String logFileName = null;
        if (args.length < 1) {
            System.out.println("Usage: java -cp onix4j.jar Onix2Marc logfile [output_directory]");
            System.out.println("       java -cp onix4j.jar Onix2Marc onix_directory [output_directory]");
            return;
        } else {
            if (new File(args[0]).isDirectory()) {
                onixDirectory = args[0];
                logFileName = null;
            } else {
                logFileName = args[0];
                onixDirectory = null;
            }
        }

        String outDirectory = null;
        if (args.length < 2) {
            if (onixDirectory != null) {
                outDirectory = onixDirectory;
            } // else in-place
        } else {
            outDirectory = args[1];
        }

        List<String> fileNames;
        if (logFileName != null) {
            OnixLog log = new OnixLog(logFileName);
            EnhanceProduct.filters = Arrays.asList((Filter) new LogFileFilter(log));
            fileNames = new LogFileOnixInput(log).getFileNames();
        } else {
            //fileNames = new RecursiveFileSystemOnixInput(onixDirectory, Arrays.asList((Filter)new FileExtensionFilter())).getFileNames();
            fileNames = new SingleDirectoryFileSystemOnixInput(onixDirectory, Arrays.asList((Filter)new FileExtensionFilter())).getFileNames();
        }

        for (String fileName : fileNames) {
            final File file = new File(fileName);
            handleSingleFile(file, outDirectory != null ?  outDirectory : file.getPath());
        }
    }

    private static void handleSingleFile(File file, String outDirectory) {
        System.out.println("Processing " + file.getName());
        Source xmlInput = new StreamSource(file);
        final String outFileName = outDirectory + "/" + file.getName() + ".mrc.xml";
        Result xmlOutput = new StreamResult(new File(outFileName));

        try {
            Onix2Marc.transform(file.getAbsolutePath(), xmlInput, xmlOutput);
            System.out.println("Successfully written " + outFileName);
        } catch (TransformerException e) {
            System.out.println("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
        }
    }
}
