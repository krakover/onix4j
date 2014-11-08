package org.onix4j.writer;

import com.thoughtworks.xstream.io.StreamException;
import org.apache.log4j.Logger;
import org.onix4j.exporter.ExportData;
import org.onix4j.exporter.Exporter;
import org.onix4j.model.Onix;
import org.onix4j.model.OnixProduct;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * User: Neta
 * Date: 6/8/14
 * Time: 1:10 PM
 */
public class AggragatorFileWriter<T extends OnixProduct> implements FileWriter<T> {
    private File file;
    private FileOutputStream output;
    private ExportData exportData;
    private Exporter<T> exporter;

    private static Logger logger = Logger.getLogger(AggragatorFileWriter.class);

    public AggragatorFileWriter(Exporter<T> exporter, String fileName) {
        file = new File(fileName);
        this.exporter = exporter;
    }

    public void init() throws FileNotFoundException {
        exportData = new ExportData();
    }

    public void processOnix(Onix<T> onix) {
        try {
            exportData.setExportData(exporter.<T>export(onix, true, exportData));
        } catch (StreamException e) {
            logger.error("Error processing " + file.getName() + " :" + e.getMessage() + ". Skipping.");
        }
    }

    public void done() throws IOException {
        output = new FileOutputStream(file);
        output.write(exporter.export(exportData).toString().getBytes());
        output.close();
    }
}
