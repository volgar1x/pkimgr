# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create email: "test@test", password: "test"

user.authorities.create([
  { name: "Hello1", email: "hello1@hello.hello", website: "http://hello1.hello", password: "hello" },
  { name: "Hello2", email: "hello2@hello.hello", website: "http://hello2.hello", password: "hello" },
  { name: "Hello3", email: "hello3@hello.hello", website: "http://hello3.hello", password: "hello" },
])

p = CertProfile.create name: "(empty)"

a = user.authorities.first!
a.update!(sign_key_pem: "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-256-CTR,1CF3727330C952CC5ED5E8905E13C6BB\n\nnxtuMH2J0j05pYoH10JvC4zdm0TaAsdHwDGWUoqTRG6cJdEFz3ewgdmtaoVD2hG2\nTVxKttG/6KyXvTvvA6OaXmVMGZCM5c86cUPwFf/PX/v5xXIvmd4qEyEgR43MspWf\n4KIav7++0NZ95DnzqscXsE0U2inryK2HPD0sdRuC22CsYAjIz8CkwR2gKAPfXrGm\nAIUqeMdDHIDuvCvDV4QJR/k9sghFYkRvNLzHwXyRaO4s1GmuTemjTLIxehP3504t\nKjrzG5renNjPxapsLPNUHJo9kkjbzKJlwdtiunca1+AHbo41h0z2dceemejV+PXF\ne+TMjOjZCH6SVtTQLeoOA+mE5mRHsEYUSx6wT5Knq3AzHhopVtj/vmYHOiv7LeBq\nr0ireaPj/jWVTCEFBOy8lI3hXhxmeBImeWZ+EnQauQP3OpjblvhOSHQoManu97iw\n/+lLzjJMGUCz95PZwIH8Q2c9FERWrRqwpgbOma28Bv2O5SDeKT86pSFbw/lNIQHU\n3IMXryQOFu8W718RLgsLstKS45JjI9fUnZZUfSmeMYYR6VMRZMFuhrxsBEU2Di3J\nNqT3Wk8M7O7LVs/+UR34GfLGLJ0jjiYuLFjyx+xCiq3bMj5jlrlPImMHy+JUAgqL\nN49sSssx0u/mQ/urTTuSjQoz0fHhdevkU984O45Cx6Et5GIn0E5I4FnzRCNY8Ck7\niz6a37BdfpCMc6gk7ke1BYO/mQ3EuH3iGPrjH+toRkfTRshS5Uv3kD/R2y/wTNfN\nTgUS5VOfR9JiJP5fCnegEl7N+J3CczzH2+Rw5U34/xy5+yZIfQ/wo+EWpPcdwnRT\nhmccrh4A42dn5DuZEYtxBM4eSp0k3ow4Q1k6tjlv5g/oZt2MUv2B2T30gtLJBJhr\nowvfQoZXis6vsyyz42RInbw15wQYpFwmzlJPPF+mfYYjHMu+RgCNYYys+bQ+X3xo\nHZDzviUcd9s9Q74oS6cf2RDHpZZgGFfxNixrzJBhVHJkkDzlap/THSZ53pzD4s4P\nhAoPtxf8MVHnh2WAplKO58p+q1OL/0GgSzSjszqDsQfI0HD64O14s+BDco8IFZu6\nP+WCFyHCrugtKgY1DB87j0yTNlnXvbf4MELvGSxvYaUVOWDCwoT1w/fq0gMa/4sR\nQdxzceXun8YMn8lxZVeLqjgdogwVVByH+C6q+f62Cw3LGI4KU15dlPGt8xJqBJO4\nvVwxdYGHFOu7JZ6rTrXEyafm63iIlxEsRVqQRekJXaAAzEkDKfPOVkMmYzClpxrX\nTdl+0g4+64IWm/gTCNbWAny1wSg11hmggBOTOBSX8raQc54loLhj5fXmtblMNuD9\nY6Jdpqf3fAsYDU1CCcGmMME9WTtfnJyhgUSXdGvdU6st5sAuoWGDXt9BBvUaf/OM\n8WWv+qtOHNiVa65VTk0E0TgDdZ5t2cnY2DuQUI2PIuEzzG4yFv2hjS1gd/V8We7l\nOADAC3Dn/hrlpLEWGV+FDeF7oAvBr2ENpe9/+jiUBeiprMdkvs57hLFqghx0Ano+\n2Bgw25G9DAoMizWn9oYIVYgVSMXsAPQW5/whElu+3IJBkEzn99zZ\n-----END RSA PRIVATE KEY-----\n")

a.certificates.create(
  issuer: a,
  subject: a,
  profile: p,
  pem: """-----BEGIN CERTIFICATE-----
MIIEMjCCAxqgAwIBAgIJAOU9Z/kFGYo/MA0GCSqGSIb3DQEBCwUAMIGtMQswCQYD
VQQGEwJGUjEYMBYGA1UECAwPSGF1dGUtTm9ybWFuZGllMRYwFAYDVQQHDA1TYWlu
dC1FdGllbm5lMRwwGgYDVQQKDBNVbml2ZXJzaXRlIGRlIFJvdWVuMQ4wDAYDVQQL
DAVNMlNTSTEUMBIGA1UEAwwLVG9tY2F0IFJvb3QxKDAmBgkqhkiG9w0BCQEWGXBy
b2pldG0yc3NpQHVuaXYtcm91ZW4uZnIwHhcNMTgwMjEzMTY1NzUzWhcNMTkwMjEz
MTY1NzUzWjCBrTELMAkGA1UEBhMCRlIxGDAWBgNVBAgMD0hhdXRlLU5vcm1hbmRp
ZTEWMBQGA1UEBwwNU2FpbnQtRXRpZW5uZTEcMBoGA1UECgwTVW5pdmVyc2l0ZSBk
ZSBSb3VlbjEOMAwGA1UECwwFTTJTU0kxFDASBgNVBAMMC1RvbWNhdCBSb290MSgw
JgYJKoZIhvcNAQkBFhlwcm9qZXRtMnNzaUB1bml2LXJvdWVuLmZyMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp85TYfOnBgN60kOLL5dJbwSzXilxUGH+
wFhdLUHufd+Amev83x4LqWdcDsk6eAFmOCX/IMRxkgzzVdJSjWOlwSz21zYKu3re
sOsBjzXV/LDl3qw3+F7E2BfdxC2C6piezLstiXY4bX7/g3tNNnx9BYRHMlo4GHe3
kCzGCsV50qL7MF+3PHudLsm1Qx5163eh2FGjjWEtuqR4pmHGBKJfMFmtttBW2Bcn
CidWHH1LvkvOCBYv/IPh1L80kkM7cloPrgVyIPPWFLGba1NJUekb72LfbxPcvSQy
aF/1Kbhk5OwcostLBkPUUMGpapLG6EWYlGWmpba8BG0fkNOGLpaWaQIDAQABo1Mw
UTAdBgNVHQ4EFgQUFZK4XhdJqk5H2hyCfMPPmwVWxqowHwYDVR0jBBgwFoAUFZK4
XhdJqk5H2hyCfMPPmwVWxqowDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsF
AAOCAQEARmikVdk1+t+lw5rpVPIZx3dZPNZISwDARMZmaTBcy3d7v2OrGPXPcfJZ
0+6PZaYJX/5QimlfJgYxkfzBmhql3ktXgCb4sK/WRJR0fJ3RyYoNscLAhAHswljU
5iaXa2Q/N6f1Kvf9v7zBfnLdz+7gGYEfWHiCPk12l4cJnjz/Gj5KVMBqkqVI51nh
iqN1kd2HvsCygu4ryZpe/4TJiiLVrEtewNugq8wmMhj32v2aNBg66JQSGNLbHps7
0SBPLl1R/q80qoLjym5LjjuR0L6cJT3QbpXx9ClrRpgzHVymAA75fnIklMcMJcYB
zdHeMvi8vwj9sXhskrMUBSyvA8F67g==
-----END CERTIFICATE-----""",
)
