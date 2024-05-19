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
	-- FOREIGN KEY(parent_sha256) REFERENCES certificates(sha256),
	cert_type TEXT,
	revocation TEXT,
	auditor TEXT,
	same_auditor_as_parent BOOLEAN,
	audit_url TEXT,
	audit_type TEXT,
	audit_statement_date TEXT,
	audit_start_date TEXT,
	audit_end_date TEXT,
	br_audit_url TEXT,
	br_audit_type TEXT,
	br_audit_statement_date TEXT,
	br_audit_start_date TEXT,
	br_audit_end_date TEXT,
	tls_evg_audit_url TEXT,
	tls_evg_audit_type TEXT,
	tls_evg_audit_statement_date TEXT,
	tls_evg_audit_start_date TEXT,
	tls_evg_audit_end_date TEXT,
	code_audit_url TEXT,
	code_audit_type TEXT,
	code_audit_statement_date TEXT,
	code_audit_start_date TEXT,
	code_audit_end_date TEXT,
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
	sub_ca_owner TEXT,
	full_ca_crl_url TEXT,
	partitioned_crls_json_array TEXT,
	valid_from_gmt TEXT,
	valid_to_gmt TEXT,
	pem TEXT
);

INSERT OR IGNORE INTO certificates
SELECT
	certrecords."SHA-256 Fingerprint",
	certrecords."CA Owner",
	certrecords."Certificate Name",
	parentrecords."SHA-256 Fingerprint",
	certrecords."Certificate Record Type",
	certrecords."Revocation Status",
	certrecords."Auditor",
	"Audits Same as Parent",
	certrecords."Standard Audit URL",
	certrecords."Standard Audit Type",
	REPLACE(certrecords."Standard Audit Statement Date", ".", "-"),
	REPLACE(certrecords."Standard Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."Standard Audit Period End Date", ".", "-"),
	certrecords."TLS BR Audit URL",
	certrecords."TLS BR Audit Type",
	REPLACE(certrecords."TLS BR Audit Statement Date", ".", "-"),
	REPLACE(certrecords."TLS BR Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."TLS BR Audit Period End Date", ".", "-"),
	certrecords."TLS EVG Audit URL",
	certrecords."TLS EVG Audit Type",
	REPLACE(certrecords."TLS EVG Audit Statement Date", ".", "-"),
	REPLACE(certrecords."TLS EVG Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."TLS EVG Audit Period End Date", ".", "-"),
	certrecords."Code Signing Audit URL",
	certrecords."Code Signing Audit Type",
	REPLACE(certrecords."Code Signing Audit Statement Date", ".", "-"),
	REPLACE(certrecords."Code Signing Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."Code Signing Audit Period End Date", ".", "-"),
	certrecords."Certificate Policy (CP) URL",
	certrecords."Certificate Practice Statement (CPS) URL",
	REPLACE(certrecords."CP/CPS Last Updated Date", ".", "-"),
	certrecords."CP/CPS Same as Parent?",
	certrecords."Test Website URL - Valid",
	certrecords."Test Website URL - Expired",
	certrecords."Test Website URL - Revoked",
	certrecords."Technically Constrained",
	includedrootcerts."Apple Status",
	includedrootcerts."Apple Trust Bits",
	certrecords."Mozilla Status",
	"Mozilla Trust Bits",
	certrecords."Microsoft Status",
	"Microsoft EKUs For DTBs",
	"Google Chrome Status",
	certrecords."Subordinate CA Owner",
	certrecords."Full CRL Issued By This CA",
	certrecords."JSON Array of Partitioned CRLs",
	REPLACE(certrecords."Valid From (GMT)", ".", "-"),
	REPLACE(certrecords."Valid To (GMT)", ".", "-"),
	"X.509 Certificate (PEM)"
FROM
	certrecords
LEFT JOIN includedrootcerts USING ("SHA-256 Fingerprint")
LEFT JOIN pems USING ("SHA-256 Fingerprint")
LEFT JOIN certrecords AS parentrecords ON certrecords."Parent Salesforce Record ID" = parentrecords."Salesforce Record ID";

-- Drop All Intermediate Table to Reduce Database Size
DROP TABLE certrecords;
DROP TABLE includedrootcerts;
DROP TABLE pems;
VACUUM;

.headers on
.output CCADB.csv
SELECT * FROM certificates;
