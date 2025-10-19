#!/bin/sh
set -eu

curl https://ccadb.my.salesforce-sites.com/ccadb/AllCertificateRecordsCSVFormatv4 > AllCertRecords.csv
curl https://ccadb.my.salesforce-sites.com/ccadb/AllIncludedRootCertsCSV > AllIncludedRootCerts.csv
curl "https://ccadb.my.salesforce-sites.com/ccadb/AllCertificatePEMsCSVFormat?NotBeforeDecade=1990" > PEMs1990.csv
curl "https://ccadb.my.salesforce-sites.com/ccadb/AllCertificatePEMsCSVFormat?NotBeforeDecade=2000" > PEMs2000.csv
curl "https://ccadb.my.salesforce-sites.com/ccadb/AllCertificatePEMsCSVFormat?NotBeforeDecade=2010" > PEMs2010.csv
curl "https://ccadb.my.salesforce-sites.com/ccadb/AllCertificatePEMsCSVFormat?NotBeforeDecade=2020" > PEMs2020.csv

sqlite3 CCADB.db < ccadb-import.sql
