package org.onix4j.reader;

import org.onix4j.filter.Filter;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 11:57 AM
 */
public class RecursiveFileSystemOnixInput implements OnixInput {
    private List<String> fileNames;

    public RecursiveFileSystemOnixInput(String directory, List<Filter> filters) {
        fileNames = new ArrayList<String>();
        final File onixFile = new File(directory);
        recursivelyAddFileNames(onixFile, filters);
    }

    public void recursivelyAddFileNames(File onixFile, List<Filter> filters) {
         if (onixFile.isDirectory()) {
             for (File file : onixFile.listFiles()) {
                 recursivelyAddFileNames(file, filters);
             }
         } else {
             boolean filtered = false;
             for (Filter filter : filters) {
                 if (!filter.useFile(onixFile.getName())) {
                     filtered = true;
                     break;
                 }
             }
             if (!filtered) {
                 fileNames.add(onixFile.getAbsolutePath());
             }
         }
    }

    public List<String> getFileNames() {
        return fileNames;
    }
}
