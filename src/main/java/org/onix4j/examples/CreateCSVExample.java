package org.onix4j.examples;

import com.thoughtworks.xstream.io.StreamException;
import org.apache.commons.cli.*;
import org.onix4j.exporter.CSVExporter;
import org.onix4j.exporter.ExportData;
import org.onix4j.filter.FileExtensionFilter;
import org.onix4j.filter.Filter;
import org.onix4j.model.BasicProduct;
import org.onix4j.model.Onix;
import org.onix4j.reader.LogFileOnixInput;
import org.onix4j.reader.RecursiveFileSystemOnixInput;
import org.onix4j.transform.Onix2BasicProductsXML;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * User: Neta
 * Date: 6/27/14
 * Time: 11:00 AM
 */
public class CreateCSVExample {
    public static void main(String args[]) throws IOException {
        Options options = new Options();

        options.addOption("l", "lazy", false, "should use existing product files");
        options.addOption("u", "unique", false, "should filter duplicate products");
        options.addOption("o", "outfile", false, "output log file name");
        options.addOption("d", "onix-directory", true, "directory of onix files");
        options.addOption("ol", "onix-log-file", true, "log file of onix files");

        CommandLineParser parser = new BasicParser();
        CommandLine cmd = null;
        try {
            cmd = parser.parse( options, args);
        } catch (ParseException e) {
            System.err.println("Error parsing command line arguemnts: " + e.getMessage());
            return;
        }

        final String onixDirectory = cmd.getOptionValue("d");
        final String logFileName = cmd.getOptionValue("ol");
        if (onixDirectory == null && onixDirectory == null) {
            // automatically generate the help statement
            System.err.println("Need to specify log file or onix directory");
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp( "CreateCSVExample", options );
            return;
        }

        boolean isLazy = cmd.hasOption("l");
        boolean isUnique = cmd.hasOption("u");

        String outFileName = cmd.getOptionValue("o");
        if (outFileName == null) {
            if (new File(onixDirectory).isDirectory()) {
                outFileName = onixDirectory + "/united.product.log";
            } else {
                outFileName = onixDirectory + ".log";
            }
        }

        FileOutputStream output = new FileOutputStream(outFileName);
        ExportData exportData = new ExportData();

        List<String> fileNames;
        if (onixDirectory != null) {
            fileNames = new RecursiveFileSystemOnixInput(onixDirectory,
                Arrays.asList((Filter) new FileExtensionFilter())).getFileNames();
        } else { // logFileName != null
            fileNames = new LogFileOnixInput(logFileName).getFileNames();
        }

        for (String fileName : fileNames) {
            try {
                handleSingleFile(exportData, new File(fileName), isLazy, isUnique);
            } catch(Exception e) {
                System.err.println("skipping " + fileName);
            }
        }

        output.write(new CSVExporter().export(exportData).getBytes());
        output.close();
    }

    private static void handleSingleFile(ExportData exportData, File file, boolean isLazy, boolean isUnique) {
        System.out.println("Processing " + file.getAbsolutePath());
        final Onix2BasicProductsXML<BasicProduct> onix2BasicProductsXML = new Onix2BasicProductsXML<BasicProduct>();
        onix2BasicProductsXML.init(BasicProduct.class);
        Onix<BasicProduct> onix = onix2BasicProductsXML.transform(file, isLazy);
        if (new FileExtensionFilter().useOnix(onix)) {
            try {
                exportData.setExportData(new CSVExporter().export(onix, isUnique, exportData));
            } catch (StreamException e) {
                System.err.println("Error processing " + file.getAbsolutePath() + " :" + e.getMessage() + ". Skipping.");
            }
        }
    }
}
