FROM alpine/curl:3.14 AS dependency-downloader

RUN curl -o /tmp/flink-sql-connector-hive-3.1.3_2.12-1.18.0.jar https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-3.1.3_2.12/1.18.0/flink-sql-connector-hive-3.1.3_2.12-1.18.0.jar
RUN curl -o /tmp/flink-connector-files-1.18.0.jar https://repo1.maven.org/maven2/org/apache/flink/flink-connector-files/1.18.0/flink-connector-files-1.18.0.jar
RUN curl -o /tmp/hadoop-mapreduce-client-core-3.1.0.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-core/3.1.0/hadoop-mapreduce-client-core-3.1.0.jar
RUN curl -o /tmp/hadoop-aws-3.1.0.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.1.0/hadoop-aws-3.1.0.jar
RUN curl -o /tmp/aws-java-sdk-bundle-1.12.654.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.654/aws-java-sdk-bundle-1.12.654.jar

# ----

FROM registry.ververica.com/v2.12/vvp-gateway:2.12.0

COPY catalog-meta.yaml /vvp/sql/opt/catalogs/hive/catalog-meta.yaml

COPY --from=dependency-downloader /tmp/flink-sql-connector-hive-3.1.3_2.12-1.18.0.jar /vvp/sql/opt/catalogs/hive/flink-sql-connector-hive-3.1.3_2.12-1.18.0.jar
COPY --from=dependency-downloader /tmp/flink-connector-files-1.18.0.jar /vvp/sql/opt/catalogs/hive/flink-connector-files-1.18.0.jar
COPY --from=dependency-downloader /tmp/hadoop-mapreduce-client-core-3.1.0.jar /vvp/sql/opt/catalogs/hive/hadoop-mapreduce-client-core-3.1.0.jar
COPY --from=dependency-downloader /tmp/hadoop-aws-3.1.0.jar /vvp/sql/opt/catalogs/hive/hadoop-aws-3.1.0.jar
COPY --from=dependency-downloader /tmp/aws-java-sdk-bundle-1.12.654.jar /vvp/sql/opt/catalogs/hive/aws-java-sdk-bundle-1.12.654.jar
