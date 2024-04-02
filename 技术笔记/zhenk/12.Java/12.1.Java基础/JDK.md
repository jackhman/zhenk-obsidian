# try-with-resources 语句

`try`-with-resources 语句是一个 `try` 语句，它声明一个或多个资源。_资源_ 是在程序完成后必须关闭的对象。`try`-with-resources 语句确保在语句结束时关闭每个资源。实现 `java.lang.AutoCloseable` 的任何对象（包括实现 `java.io.Closeable` 的所有对象）都可以用作资源。

以下示例从文件中读取第一行。它使用 `BufferedReader` 的实例从文件中读取数据。`BufferedReader` 是在程序完成后必须关闭的资源：

```java
static String readFirstLineFromFile(String path) throws IOException {
    try (BufferedReader br =
                   new BufferedReader(new FileReader(path))) {
        return br.readLine();
    }
}
```


在此示例中，`try`-with-resources 语句中声明的资源是 `BufferedReader`。声明语句出现在 `try` 关键字后面的括号内。Java SE 7 及更高版本中的类 `BufferedReader` 实现了接口 `java.lang.AutoCloseable`。因为 `BufferedReader` 实例是在 `try`-with-resource 语句中声明的，所以无论 `try` 语句是否正常完成或中断(作为方法 `BufferedReader.readLine` 抛出 `IOException` 的结果)，它都将被关闭。

在 Java SE 7 之前，你可以使用 `finally` 块来确保资源已关闭，无论 `try` 语句是正常完成还是中断。以下示例使用 `finally` 块而不是 `try`-with-resources 语句：

```java
static String readFirstLineFromFileWithFinallyBlock(String path)
                                                     throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
        if (br != null) br.close();
    }
}
```

但是，在此示例中，如果方法 `readLine` 和 `close` 都抛出异常，则方法 `readFirstLineFromFileWithFinallyBlock` 将从 `finally` 块抛出异常;从 `try` 块抛出的异常被抑制。相反，在示例 `readFirstLineFromFile` 中，如果从 `try` 块和 `try`-with-resources 语句抛出异常，则该方法 `readFirstLineFromFile` 抛出 `try` 块引发的异常;从 `try`-with-resources 块抛出的异常被抑制。在 Java SE 7 及更高版本中，你可以获取抑制的异常;有关详细信息，请参阅 [Suppressed Exceptions](https://pingfangx.github.io/java-tutorials/essential/exceptions/tryResourceClose.html#suppressed-exceptions) 部分。

你可以在 `try`-with-resources 语句中声明一个或多个资源。以下示例获取 zip 文件 `zipFileName` 中打包的文件的名称，并创建一个包含这些文件名称的文本文件：

```java
public static void writeToFileZipFileContents(String zipFileName,  
                                              String outputFileName) throws java.io.IOException {  
  
    java.nio.charset.Charset charset = java.nio.charset.StandardCharsets.US_ASCII;  
    java.nio.file.Path outputFilePath = java.nio.file.Paths.get(outputFileName);  
  
    // Open zip file and create output file with   
    // try-with-resources statement  
  
    try (java.util.zip.ZipFile zf =  
                 new java.util.zip.ZipFile(zipFileName);  
         java.io.BufferedWriter writer =  
                 java.nio.file.Files.newBufferedWriter(outputFilePath, charset)) {  
        // Enumerate each entry  
        for (java.util.Enumeration entries =  
             zf.entries(); entries.hasMoreElements(); ) {  
            // Get the entry name and write it to the output file  
            String newLine = System.getProperty("line.separator");  
            String zipEntryName = ((java.util.zip.ZipEntry) entries.nextElement()).getName() + newLine;  
            writer.write(zipEntryName, 0, zipEntryName.length());  
        }  
    }  
}
```

在此示例中，`try`-with-resources 语句包含两个以分号分隔的语句：`ZipFile` 和 `BufferedWriter`。当直接跟随它的代码块正常或由于异常而终止时，`BufferedWriter` 和 `ZipFile` 对象的 `close` 方法是按此顺序自动调用。请注意，资源的 `close` 方法按其创建的 _相反_ 顺序调用。

以下示例使用 `try`-with-resources 语句自动关闭 `java.sql.Statement` 对象：

```java
public static void viewTable(Connection con) throws SQLException {

    String query = "select COF_NAME, SUP_ID, PRICE, SALES, TOTAL from COFFEES";

    **try (Statement stmt = con.createStatement())** {
        ResultSet rs = stmt.executeQuery(query);

        while (rs.next()) {
            String coffeeName = rs.getString("COF_NAME");
            int supplierID = rs.getInt("SUP_ID");
            float price = rs.getFloat("PRICE");
            int sales = rs.getInt("SALES");
            int total = rs.getInt("TOTAL");

            System.out.println(coffeeName + ", " + supplierID + ", " + 
                               price + ", " + sales + ", " + total);
        }
    } catch (SQLException e) {
        JDBCTutorialUtilities.printSQLException(e);
    }
}
```

此示例中使用的资源 `java.sql.Statement` 是 JDBC 4.1 及更高版本 API 的一部分。

**注意**:`try`-with-resources 语句可以像普通的 `try` 语句一样具有 `catch` 和 `finally` 块。在 `try`-with-resources 语句中，任何 `catch` 或 `finally` 块在声明的资源关闭后运行。

## 抑制的异常

可以从与 `try`-with-resources 语句关联的代码块中抛出异常。在示例 `writeToFileZipFileContents` 中，可以从 `try` 块中抛出异常，并且可以从 `try`-with-resources 语句中抛出最多两个异常 - 当它尝试关闭 `ZipFile` 和 `BufferedWriter` 对象时。如果从 `try` 块抛出异常并且从 `try`-with-resources 语句抛出一个或多个异常，那么从 `try`-with-resources 语句抛出的异常被抑制，块抛出的异常是 `writeToFileZipFileContents` 方法抛出的异常。你可以通过从 `try` 块抛出的异常中调用 `Throwable.getSuppressed` 方法来获取这些抑制的异常。

## 实现 AutoCloseable 或 Closeable 接口的类

请参阅 [`AutoCloseable`](https://docs.oracle.com/javase/8/docs/api/java/lang/AutoCloseable.html) 和 [`Closeable`](https://docs.oracle.com/javase/8/docs/api/java/io/Closeable.html) 接口的 Javadoc，以获取实现这些接口之一的类列表。`Closeable` 接口继承了 `AutoCloseable` 接口。`Closeable` 接口的 `close` 方法抛出 `IOException` 类型的异常，而 `AutoCloseable` 接口的 `close` 方法抛出 `Exception` 类型的异常。因此，`AutoCloseable` 接口的子类可以覆盖 `close` 方法的此行为，以抛出特殊异常，例如 `IOException`，或者根本没有异常。