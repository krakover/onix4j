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
public class SingleDirectoryFileSystemOnixInput implements OnixInput {
    private List<String> fileNames;

    public SingleDirectoryFileSystemOnixInput(String directory, List<Filter> filters) {
        fileNames = new ArrayList<String>();
        final File onixFile = new File(directory);

        if (onixFile.isDirectory()) {
            for (File file : onixFile.listFiles()) {
                boolean filtered = false;
                for (Filter filter : filters) {
                    if (!filter.useFile(file.getName())) {
                        filtered = true;
                        break;
                    }
                }
                if (!filtered) {
                    fileNames.add(file.getAbsolutePath());
                }
             }
         } else {
             boolean filtered = false;
             for (Filter filter : filters) {
                 if (!filter.useFile(onixFile.getAbsolutePath())) {
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
