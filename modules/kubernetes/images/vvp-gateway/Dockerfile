FROM alpine/curl:3.14 AS dependency-downloader

RUN curl -o /tmp/flink-sql-connector-mysql-cdc-3.0.0.jar https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-mysql-cdc/3.0.0/flink-sql-connector-mysql-cdc-3.0.0.jar
RUN curl -o /tmp/flink-connector-base-1.18.0.jar https://repo1.maven.org/maven2/org/apache/flink/flink-connector-base/1.18.0/flink-connector-base-1.18.0.jar

RUN curl -o /tmp/paimon-flink-1.18-0.6.0-incubating.jar https://repo1.maven.org/maven2/org/apache/paimon/paimon-flink-1.18/0.6.0-incubating/paimon-flink-1.18-0.6.0-incubating.jar
RUN curl -o /tmp/paimon-flink-action-0.6.0-incubating.jar https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-flink-action/0.6.0-incubating/paimon-flink-action-0.6.0-incubating.jar
RUN curl -o /tmp/paimon-s3-0.6.0-incubating.jar https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-s3/0.6.0-incubating/paimon-s3-0.6.0-incubating.jar

# ----

FROM registry.ververica.com/v2.12/vvp-gateway:2.12.0

COPY connector-meta.yaml /vvp/sql/opt/connectors/mysql-cdc/connector-meta.yaml

COPY --from=dependency-downloader /tmp/flink-connector-base-1.18.0.jar /vvp/sql/opt/connectors/mysql-cdc/flink-connector-base-1.18.0.jar
COPY --from=dependency-downloader /tmp/flink-sql-connector-mysql-cdc-3.0.0.jar /vvp/sql/opt/connectors/mysql-cdc/flink-sql-connector-mysql-cdc-3.0.0.jar

COPY catalog-meta.yaml /vvp/sql/opt/catalogs/paimon/catalog-meta.yaml

COPY --from=dependency-downloader /tmp/flink-connector-base-1.18.0.jar /vvp/sql/opt/catalogs/paimon/flink-connector-base-1.18.0.jar
COPY --from=dependency-downloader /tmp/paimon-flink-1.18-0.6.0-incubating.jar /vvp/sql/opt/catalogs/paimon/paimon-flink-1.18-0.6.0-incubating.jar
COPY --from=dependency-downloader /tmp/paimon-flink-action-0.6.0-incubating.jar /vvp/sql/opt/catalogs/paimon/paimon-flink-action-0.6.0-incubating.jar
COPY --from=dependency-downloader /tmp/paimon-s3-0.6.0-incubating.jar /vvp/sql/opt/catalogs/paimon/paimon-s3-0.6.0-incubating.jar
