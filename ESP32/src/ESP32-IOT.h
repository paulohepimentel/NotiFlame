//! This file contains your configuration used to connect to Cloud IoT Core

//! Cloud iot details.
const char project_id [11] = "notiflame4";
const char location [12] = "us-central1";
const char registry_id [13] = "iot-registry";
const char device_id [11] = "iot-device";

//! Time (seconds) to expire token += 20 minutes for drift
const int jwt_exp_secs = 3600; // Maximum 24H (3600*24)

//! To get the private key run 
// openssl ec -in <private-key.pem> -noout -text
// -> NotiFlame: openssl ec -in iot-device-ec_private.pem -noout -text
const char private_key_str[96] =
    "84:ca:4c:46:f7:4d:e2:e0:31:8b:a7:1f:72:f6:b2:"
    "4f:83:ab:01:c9:7f:e4:b4:27:b2:1d:98:4a:3f:86:"
    "38:78";

//! To get the certificate for your region run:
// openssl s_client -showcerts -connect mqtt.googleapis.com:8883
const char root_cert[1270] =
    "-----BEGIN CERTIFICATE-----\n"
    "MIIDfDCCAmSgAwIBAgIJAJB2iRjpM5OgMA0GCSqGSIb3DQEBCwUAME4xMTAvBgNV\n"  
    "BAsMKE5vIFNOSSBwcm92aWRlZDsgcGxlYXNlIGZpeCB5b3VyIGNsaWVudC4xGTAX\n"
    "BgNVBAMTEGludmFsaWQyLmludmFsaWQwHhcNMTUwMTAxMDAwMDAwWhcNMzAwMTAx\n"  
    "MDAwMDAwWjBOMTEwLwYDVQQLDChObyBTTkkgcHJvdmlkZWQ7IHBsZWFzZSBmaXgg\n"
    "eW91ciBjbGllbnQuMRkwFwYDVQQDExBpbnZhbGlkMi5pbnZhbGlkMIIBIjANBgkq\n"  
    "hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzWJP5cMThJgMBeTvRKKl7N6ZcZAbKDVA\n"
    "tNBNnRhIgSitXxCzKtt9rp2RHkLn76oZjdNO25EPp+QgMiWU/rkkB00Y18Oahw5f\n"  
    "i8s+K9dRv6i+gSOiv2jlIeW/S0hOswUUDH0JXFkEPKILzpl5ML7wdp5kt93vHxa7\n"
    "HswOtAxEz2WtxMdezm/3CgO3sls20wl3W03iI+kCt7HyvhGy2aRPLhJfeABpQr0U\n"  
    "ku3q6mtomy2cgFawekN/X/aH8KknX799MPcuWutM2q88mtUEBsuZmy2nsjK9J7/y\n"
    "hhCRDzOV/yY8c5+l/u/rWuwwkZ2lgzGp4xBBfhXdr6+m9kmwWCUm9QIDAQABo10w\n"  
    "WzAOBgNVHQ8BAf8EBAMCAqQwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMC\n"
    "MA8GA1UdEwEB/wQFMAMBAf8wGQYDVR0OBBIEELsPOJZvPr5PK0bQQWrUrLUwDQYJ\n"  
    "KoZIhvcNAQELBQADggEBALnZ4lRc9WHtafO4Y+0DWp4qgSdaGygzS/wtcRP+S2V+\n"
    "HFOCeYDmeZ9qs0WpNlrtyeBKzBH8hOt9y8aUbZBw2M1F2Mi23Q+dhAEUfQCOKbIT\n"  
    "tunBuVfDTTbAHUuNl/eyr78v8Egi133z7zVgydVG1KA0AOSCB+B65glbpx+xMCpg\n"
    "ZLux9THydwg3tPo/LfYbRCof+Mb8I3ZCY9O6FfZGjuxJn+0ux3SDora3NX/FmJ+i\n"  
    "kTCTsMtIFWhH3hoyYAamOOuITpPZHD7yP0lfbuncGDEqAQu2YWbYxRixfq2VSxgv\n"
    "gWbFcmkgBLYpE8iDWT3Kdluo1+6PHaDaLg2SacOY6Go=\n"
    "-----END CERTIFICATE-----\n";
