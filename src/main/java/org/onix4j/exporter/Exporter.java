package org.onix4j.exporter;

import org.onix4j.metadata.Column;
import org.onix4j.metadata.Table;
import org.onix4j.model.Onix;
import org.onix4j.model.OnixProduct;
import org.onix4j.util.ReflectionUtils;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * User: Neta
 * Date: 5/20/14
 * Time: 9:15 PM
 */
public abstract class Exporter<T> {

    public ExportData processAnnotatedMapping(final OnixProduct object, boolean unique) {
        return processAnnotatedMapping(object, null, unique);
    }

    public ExportData processAnnotatedMapping(final OnixProduct object, final ExportData exportData, boolean unique) {
        ExportData result = new ExportData();
        if (object == null) {
            if (exportData == null) {
                return result;
            }
            if (unique) {
                return exportData.filterUniqueByColumnIndex(1);    // TODO better
            }
            return exportData;
        }

        if (!object.getClass().isAnnotationPresent(Table.class)) {
            throw new IllegalStateException("You cannot use annotation driven mapping with class that is not annotated with the "
                    + Table.class.getSimpleName() + " annotation!");
        }

        final List<Object> values = new ArrayList<Object>();
        if (exportData == null || exportData.columnNames == null || exportData.columnNames.isEmpty()) {
            result.setTableName(object.getClass().getAnnotation(Table.class).tableName());
            result.setSchemeName(object.getClass().getAnnotation(Table.class).schemaName());

            result.rows = new ArrayList<ExportData.ExportedRow>();

            final List<String> columnNames = new ArrayList<String>();
            recursivelyAddColumnsAndValues(object.getClass(), object, columnNames, values, "");
            result.columnNames = columnNames;
        } else {
            result.setExportData(exportData);
            recursivelyAddColumnsAndValues(object.getClass(), object, null, values, "");
        }

        result.rows.add(new ExportData.ExportedRow(object.getOnixMetadata(), values));

        if (unique) {
            result = result.filterUniqueByColumnIndex(1);
        }

        if (exportData != null) {
            exportData.setExportData(result);
        }

        return result;
    }

    private static void recursivelyAddColumnsAndValues(Class<? extends OnixProduct> clz,
                                                       final OnixProduct object,
                                                       final List<String> columnNames,
                                                       final List<Object> values,
                                                       final String suffix) {
        final ReflectionUtils.FieldCallback fc = new ReflectionUtils.FieldCallback() {
            public void doWith(Field field) throws IllegalArgumentException, IllegalAccessException {
                Column annotation = field.getAnnotation(Column.class);

                String columnName = annotation.columnName();
                if (field.getType().isAssignableFrom(List.class)) {
                    int columnInstances = annotation.instances();

                    Class<?> genericListClz = ReflectionUtils.getListGenericType(field);
                    List list = null;
                    if (object != null) {
                        list = (List) ReflectionUtils.getValue(field, object);
                    }

                    if (OnixProduct.class.isAssignableFrom(genericListClz)) {
                        for (int i = 1; i <= columnInstances; i++) {

                            OnixProduct value = null;
                            if (list != null && list.size() >= i) {
                                value = (OnixProduct) list.get(i-1);
                            }
                            recursivelyAddColumnsAndValues(genericListClz.asSubclass(OnixProduct.class),
                                    value,
                                    columnNames, values, "_" + i + suffix);
                        }
                    } else {
                        for (int i = 1; i <= columnInstances; i++) {
                            if (columnNames != null) {
                                columnNames.add(getColumnName(field, columnName) + "_" + i + suffix);
                            }
                            Object value = null;
                            if (list != null && list.size() >= i) {
                                value = list.get(i-1);
                            }
                            values.add(value);
                        }
                    }
                } else if (OnixProduct.class.isAssignableFrom(field.getType())) {
                    recursivelyAddColumnsAndValues(field.getType().asSubclass(OnixProduct.class),
                            (OnixProduct)ReflectionUtils.getValue(field, object), columnNames, values, suffix);
                } else {
                    if (columnNames != null) {
                        columnNames.add(getColumnName(field, columnName) + suffix);
                    }
                    values.add(object != null ? ReflectionUtils.getValue(field, object) : null);
                }
            }
        };

        ReflectionUtils.FieldFilter ff = new ReflectionUtils.FieldFilter() {
            public boolean matches(Field field) {
                return field.isAnnotationPresent(Column.class);
            }
        };

        ReflectionUtils.doWithFields(clz, fc, ff);
    }

    private static String getColumnName(Field field, String columnName) {
        return (columnName == null || columnName.isEmpty() ? field.getName() : columnName);
    }

    public <T extends OnixProduct> ExportData export(Onix<T> onix, boolean unique, ExportData exportData) {
        if (onix != null && onix.products != null && !onix.products.isEmpty()) {
            if (exportData == null) {
                exportData = processAnnotatedMapping(onix.products.get(0), unique);
            } else {
                processAnnotatedMapping(onix.products.get(0), exportData, unique);
            }
            for (int i = 1; i < onix.products.size(); i++) {
                processAnnotatedMapping(onix.products.get(i), exportData, unique);
            }
            return exportData;
        }

        return new ExportData();
    }


    public <T extends OnixProduct> ExportData export(Onix<T> onix, boolean unique) {
        if (onix != null && onix.products != null && !onix.products.isEmpty()) {
            ExportData exportData = processAnnotatedMapping(onix.products.get(0), unique);
            for (int i = 1; i < onix.products.size(); i++) {
                processAnnotatedMapping(onix.products.get(i), exportData, unique);
            }
            return exportData;
        }

        return new ExportData();
    }

    public abstract T export(ExportData exportData);

    public enum DateFormat {
        hhmm("hhmm"),
        hhmmss("hhmmss"),
        yyyyMMdd("yyyyMMdd"),
        yyyyMMddhhmm("yyyyMMddhhmm"),
        yyyyMMddhhmmss("yyyyMMddhhmmss");

        public String value;
        public boolean hasTime;
        public boolean hasDate;

        public SimpleDateFormat formatter;

        private DateFormat(String value) {
            this.value = value;
            hasTime = value.contains("hh");
            hasDate = value.contains("yyyy");
            formatter = new SimpleDateFormat(value);
        }
    }

    private static final Pattern timestampPattern = Pattern.compile("[^0-9]([0-9]{4,14})(?=[_\\.])");

    private static Calendar extractTimstampFromOnixFileName(String fileName) {
		Matcher matcher = timestampPattern.matcher(fileName);
		Calendar aux = new GregorianCalendar();
		int yyyy = 0, MM = 0, dd = 0, hh = 0, mm = 0, ss = 0;
        while (matcher.find()) {
			String value = matcher.group(1);
            for (DateFormat format : DateFormat.values()) {
                Date timestamp = null;
                try {
                    timestamp = format.formatter.parse(value);
                } catch (ParseException e) {
                    continue;
                }

                aux.setTime(timestamp);
                if (format.hasDate) {
                    yyyy = aux.get(Calendar.YEAR);
                    MM = aux.get(Calendar.MONTH);
                    dd = aux.get(Calendar.DAY_OF_MONTH);
                }
                if (format.hasTime) {
                    hh = aux.get(Calendar.HOUR);
                    mm = aux.get(Calendar.MINUTE);
                    ss = aux.get(Calendar.SECOND);
                }

                if (yyyy > 0)
                    return new GregorianCalendar(yyyy, MM, dd, hh, mm, ss);
            }
        }
        return null;
	}

}
