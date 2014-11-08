package org.onix4j.examples;

import com.thoughtworks.xstream.io.StreamException;
import org.apache.commons.cli.*;
import org.onix4j.exporter.ExportData;
import org.onix4j.exporter.LogExporter;
import org.onix4j.filter.FileExtensionFilter;
import org.onix4j.filter.Filter;
import org.onix4j.model.BasicProduct;
import org.onix4j.model.Onix;
import org.onix4j.reader.RecursiveFileSystemOnixInput;
import org.onix4j.transform.Onix2BasicProductsXML;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * User: Neta
 * Date: 6/7/14
 * Time: 10:36 AM
 */
public class CreateLogFileExample {
    public static void main(String args[]) throws IOException {
        Options options = new Options();

        options.addOption("l", "lazy", false, "should use existing product files");
        options.addOption("u", "duplicates", false, "should keep duplicate products");
        options.addOption("o", "outfile", false, "output log file name");
        final Option onixDir = new Option("d", "onix-directory", true, "directory of onix files");
        onixDir.setRequired(true);
        options.addOption(onixDir);

        CommandLineParser parser = new BasicParser();
        CommandLine cmd = null;
        try {
            cmd = parser.parse( options, args);
        } catch (ParseException e) {
            System.err.println("Error parsing command line arguemnts: " + e.getMessage());
            return;
        }

        final String onixDirectory = cmd.getOptionValue("d");
        if (onixDirectory == null) {
            // automatically generate the help statement
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp( "CreateLogFileExample", options );
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

        List<String> fileNames = new RecursiveFileSystemOnixInput(onixDirectory,
                Arrays.asList((Filter) new FileExtensionFilter())).getFileNames();

        for (String fileName : fileNames) {
            try {
                handleSingleFile(exportData, new File(fileName), isLazy, isUnique);
            } catch(Exception e) {
                System.err.println("skipping " + fileName);
            }
        }

        output.write(new LogExporter().export(exportData).toString().getBytes());
        output.close();
    }

    private static void handleSingleFile(ExportData exportData, File file, boolean isLazy, boolean isUnique) {
        System.out.println("Processing " + file.getAbsolutePath());
        final Onix2BasicProductsXML<BasicProduct> onix2BasicProductsXML = new Onix2BasicProductsXML<BasicProduct>();
        onix2BasicProductsXML.init(BasicProduct.class);
        Onix<BasicProduct> onix = onix2BasicProductsXML.transform(file, isLazy);
        if (new FileExtensionFilter().useOnix(onix)) {
            try {
                exportData.setExportData(new LogExporter().export(onix, isUnique, exportData));
            } catch (StreamException e) {
                System.out.println("Error processing " + file.getAbsolutePath() + " :" + e.getMessage() + ". Skipping.");
            }
        }
    }
}
