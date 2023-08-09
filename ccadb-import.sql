PRAGMA foreign_keys=off;

.mode csv
.import AllCertRecords.csv certrecords
.import AllIncludedRootCerts.csv includedrootcerts
.import PEMs1990.csv pems
.import PEMs2000.csv pems
.import PEMs2010.csv pems
.import PEMs2020.csv pems


CREATE TABLE certificates (
	sha256 TEXT PRIMARY KEY,
	ca_owner TEXT,
	cert_name TEXT,
	parent_sha256 TEXT,
	FOREIGN KEY(parent_sha256) REFERENCES certificates(sha256),
	cert_type TEXT,
	revocation TEXT,
	auditor TEXT,
	same_auditor_as_parent BOOLEAN,
	audit_url TEXT,
	audit_type TEXT,
	audit_statement_date TEXT,
	audit_period_start_date TEXT,
	audit_period_end_date TEXT,
	br_audit_url TEXT,
	br_audit_type TEXT,
	br_audit_statement_date TEXT,
	br_audit_start_date TEXT,
	br_audit_end_date TEXT,
	ev_ssl_audit_url TEXT,
	ev_ssl_audit_type TEXT,
	ev_ssl_audit_statement_date TEXT,
	ev_ssl_audit_start_date TEXT,
	ev_ssl_audit_end_date TEXT,
	ev_code_audit_url TEXT,
	ev_code_audit_statement_date TEXT,
	ev_code_audit_statement_start_date TEXT,
	ev_code_audit_statement_end_date TEXT,
	cert_policy_url TEXT,
	cert_practice_statement_url TEXT,
	cert_policy_practice_statement_last_updated_date TEXT,
	same_cert_policy_practice_as_parent BOOLEAN,
	test_site_valid_url TEXT,
	test_site_expired_url TEXT,
	test_site_revoked_url TEXT,
	technically_constrained BOOLEAN,
	apple_status TEXT,
	apple_trust TEXT,
	mozilla_status TEXT,
	mozilla_trust TEXT,
	microsoft_status TEXT,
	microsoft_trust TEXT,
	chrome_status TEXT,
	chrome_trust TEXT,
	sub_ca_owner TEXT,
	full_ca_crl_url TEXT,
	partitioned_crls_json_array TEXT,
	valid_from_gmt TEXT,
	valid_to_gmt TEXT,
	pem TEXT
);

INSERT INTO certificates
SELECT
	"SHA-256 Fingerprint",
	certrecords."CA Owner",
	certrecords."Certificate Name",
	(SELECT "SHA-256 Fingerprint" FROM certrecords WHERE "Salesforce Record ID" = 
	parent_sha256 TEXT,
	FOREIGN KEY(parent_sha256) REFERENCES certificates(sha256),
	cert_type TEXT,
	revocation TEXT,
	auditor TEXT,
	same_auditor_as_parent BOOLEAN,
	audit_url TEXT,
	audit_type TEXT,
	audit_statement_date TEXT,
	audit_period_start_date TEXT,
	audit_period_end_date TEXT,
	br_audit_url TEXT,
	br_audit_type TEXT,
	br_audit_statement_date TEXT,
	br_audit_start_date TEXT,
	br_audit_end_date TEXT,
	ev_ssl_audit_url TEXT,
	ev_ssl_audit_type TEXT,
	ev_ssl_audit_statement_date TEXT,
	ev_ssl_audit_start_date TEXT,
	ev_ssl_audit_end_date TEXT,
	ev_code_audit_url TEXT,
	ev_code_audit_statement_date TEXT,
	ev_code_audit_statement_start_date TEXT,
	ev_code_audit_statement_end_date TEXT,
	cert_policy_url TEXT,
	cert_practice_statement_url TEXT,
	cert_policy_practice_statement_last_updated_date TEXT,
	same_cert_policy_practice_as_parent BOOLEAN,
	test_site_valid_url TEXT,
	test_site_expired_url TEXT,
	test_site_revoked_url TEXT,
	technically_constrained BOOLEAN,
	apple_status TEXT,
	apple_trust TEXT,
	mozilla_status TEXT,
	mozilla_trust TEXT,
	microsoft_status TEXT,
	microsoft_trust TEXT,
	chrome_status TEXT,
	chrome_trust TEXT,
	sub_ca_owner TEXT,
	full_ca_crl_url TEXT,
	partitioned_crls_json_array TEXT,
	valid_from_gmt TEXT,
	valid_to_gmt TEXT,
	pem TEXT
FROM
certrecords
LEFT JOIN includedrootcert USING ("SHA-256 Fingerprint")
LEFT JOIN pems USING ("SHA-256 Fingerprint")
LEFT JOIN certrecords AS parentrecords ON certrecord."Parent Salesforce Record ID" = parentrecord."Salesforce Record ID"
