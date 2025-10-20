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
	authority_key_identifier TEXT,
	subject_key_identifier TEXT,

	auditor TEXT,
	same_auditor_as_parent BOOLEAN,
	audit_url TEXT,
	audit_type TEXT,
	audit_statement_date TEXT,
	audit_start_date TEXT,
	audit_end_date TEXT,

	netsec_audit_url TEXT,
	netsec_audit_type TEXT,
	netsec_audit_statement_date TEXT,
	netsec_audit_start_date TEXT,
	netsec_audit_end_date TEXT,

	tls_br_audit_url TEXT,
	tls_br_audit_type TEXT,
	tls_br_audit_statement_date TEXT,
	tls_br_audit_start_date TEXT,
	tls_br_audit_end_date TEXT,

	tls_evg_audit_url TEXT,
	tls_evg_audit_type TEXT,
	tls_evg_audit_statement_date TEXT,
	tls_evg_audit_start_date TEXT,
	tls_evg_audit_end_date TEXT,

	code_sign_audit_url TEXT,
	code_sign_audit_type TEXT,
	code_sign_audit_statement_date TEXT,
	code_sign_audit_start_date TEXT,
	code_sign_audit_end_date TEXT,

	smime_br_audit_url TEXT,
	smime_br_audit_type TEXT,
	smime_br_audit_statement_date TEXT,
	smime_br_audit_start_date TEXT,
	smime_br_audit_end_date TEXT,

	vmc_br_audit_url TEXT,
	vmc_br_audit_type TEXT,
	vmc_br_audit_statement_date TEXT,
	vmc_br_audit_start_date TEXT,
	vmc_br_audit_end_date TEXT,

	ca_document_repository_url TEXT,
	policy_documentation TEXT,

	cert_policy_url TEXT,
	same_cert_policy_as_parent BOOLEAN,
	cert_policy_effective_date TEXT,

	cert_practice_statement_url TEXT,
	same_cert_practice_as_parent BOOLEAN,
	cert_practice_statement_effective_date TEXT,

	cert_policy_and_practice_url TEXT,
	same_cert_policy_and_practice_as_parent BOOLEAN,
	cert_policy_and_practice_effective_date TEXT,

	plaintext_cert_policy_and_practice_url TEXT,
	plaintext_cert_policy_and_practice_same_as_parent BOOLEAN,
	plaintext_cert_policy_and_practice_effective_date TEXT,


	test_site_valid_url TEXT,
	test_site_expired_url TEXT,
	test_site_revoked_url TEXT,

	technically_constrained BOOLEAN,
	derived_trust_bits TEXT,

	tls_capable BOOLEAN,
	tls_ev_capable BOOLEAN,
	code_sign_capable BOOLEAN,
	smime_capable BOOLEAN,
	trust_bits TEXT,
	ev_oids TEXT,

	apple_status TEXT,
	apple_trust TEXT,

	mozilla_status TEXT,
	mozilla_trust TEXT,

	microsoft_status TEXT,
	microsoft_trust TEXT,

	chrome_status TEXT,

	sub_ca_owner TEXT,
	country TEXT,

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
	certrecords."Authority Key Identifier",
	certrecords."Subject Key Identifier",


	certrecords."Auditor",
	certrecords."Audits Same as Parent",
	certrecords."Standard Audit URL",
	certrecords."Standard Audit Type",
	REPLACE(certrecords."Standard Audit Statement Date", ".", "-"),
	REPLACE(certrecords."Standard Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."Standard Audit Period End Date", ".", "-"),

	certrecords."NetSec Audit URL",
	certrecords."NetSec Audit Type",
	REPLACE(certrecords."NetSec Audit Statement Date", ".", "-"),
	REPLACE(certrecords."NetSec Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."NetSec Audit Period End Date", ".", "-"),

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

	certrecords."S/MIME BR Audit URL",
	certrecords."S/MIME BR Audit Type",
	REPLACE(certrecords."S/MIME BR Audit Statement Date", ".", "-"),
	REPLACE(certrecords."S/MIME BR Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."S/MIME BR Audit Period End Date", ".", "-"),

	certrecords."VMC Audit URL",
	certrecords."VMC Audit Type",
	REPLACE(certrecords."VMC Audit Statement Date", ".", "-"),
	REPLACE(certrecords."VMC Audit Period Start Date", ".", "-"),
	REPLACE(certrecords."VMC Audit Period End Date", ".", "-"),

	certrecords."CA Document Repository",
	certrecords."Policy Documentation",

	certrecords."Certificate Policy (CP) URL",
	certrecords."CP Same as Parent",
	REPLACE(certrecords."CP Effective Date", ".", "-"),

	certrecords."Certificate Practice Statement (CPS) URL",
	certrecords."CPS Same as Parent",
	REPLACE(certrecords."CPS Effective Date", ".", "-"),

	certrecords."Certificate Practice & Policy Statement",
	certrecords."CP/CPS Same as Parent",
	REPLACE(certrecords."CP/CPS Effective Date", ".", "-"),

	certrecords."MD/AsciiDoc CP/CPS URL",
	certrecords."MD/AsciiDoc CP/CPS Same as Parent",
	REPLACE(certrecords."MD/AsciiDoc CP/CPS Effective Date", ".", "-"),

	certrecords."Test Website URL - Valid",
	certrecords."Test Website URL - Expired",
	certrecords."Test Website URL - Revoked",

	certrecords."Technically Constrained",
	certrecords."Derived Trust Bits",

	certrecords."TLS Capable",
	certrecords."TLS EV Capable",
	certrecords."Code Signing Capable",
	certrecords."S/MIME Capable",
	certrecords."Trust Bits for Root Cert",
	certrecords."EV OIDs for Root Cert",

	includedrootcerts."Apple Status",
	includedrootcerts."Apple Trust Bits",

	certrecords."Mozilla Status",
	"Mozilla Trust Bits",

	certrecords."Microsoft Status",
	"Microsoft EKUs For DTBs",

	"Google Chrome Status",

	certrecords."Subordinate CA Owner",
	certrecords."Country",

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
