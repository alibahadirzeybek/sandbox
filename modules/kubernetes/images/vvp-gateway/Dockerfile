FROM alpine/curl:3.14 AS dependency-downloader

RUN curl -o /tmp/flink-sql-connector-hive-3.1.3_2.12-1.18.1.jar https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-3.1.3_2.12/1.18.1/flink-sql-connector-hive-3.1.3_2.12-1.18.1.jar
RUN curl -o /tmp/flink-connector-files-1.18.1.jar https://repo1.maven.org/maven2/org/apache/flink/flink-connector-files/1.18.1/flink-connector-files-1.18.1.jar
RUN curl -o /tmp/flink-s3-fs-hadoop-1.18.1.jar https://repo1.maven.org/maven2/org/apache/flink/flink-s3-fs-hadoop/1.18.1/flink-s3-fs-hadoop-1.18.1.jar

RUN curl -o /tmp/hadoop-mapreduce-client-core-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-core/3.3.6/hadoop-mapreduce-client-core-3.3.6.jar
RUN curl -o /tmp/hadoop-aws-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.6/hadoop-aws-3.3.6.jar
RUN curl -o /tmp/aws-java-sdk-bundle-1.12.664.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.664/aws-java-sdk-bundle-1.12.664.jar

# ----

FROM registry.ververica.com/v2.12/vvp-gateway:2.12.0

COPY catalog-meta.yaml /vvp/sql/opt/catalogs/hive/catalog-meta.yaml

COPY --from=dependency-downloader /tmp/flink-sql-connector-hive-3.1.3_2.12-1.18.1.jar /vvp/sql/opt/catalogs/hive/flink-sql-connector-hive-3.1.3_2.12-1.18.1.jar
COPY --from=dependency-downloader /tmp/flink-connector-files-1.18.1.jar /vvp/sql/opt/catalogs/hive/flink-connector-files-1.18.1.jar
COPY --from=dependency-downloader /tmp/flink-s3-fs-hadoop-1.18.1.jar /vvp/sql/opt/catalogs/hive/flink-s3-fs-hadoop-1.18.1.jar

COPY --from=dependency-downloader /tmp/hadoop-mapreduce-client-core-3.3.6.jar /vvp/sql/opt/catalogs/hive/hadoop-mapreduce-client-core-3.3.6.jar
COPY --from=dependency-downloader /tmp/hadoop-aws-3.3.6.jar /vvp/sql/opt/catalogs/hive/hadoop-aws-3.3.6.jar
COPY --from=dependency-downloader /tmp/aws-java-sdk-bundle-1.12.664.jar /vvp/sql/opt/catalogs/hive/aws-java-sdk-bundle-1.12.664.jar
