JasperReport as a service
==========================

Spring-boot+SwaggerUI+JasperReport.

Mvn
=============

mvn spring-boot:run -Dspring.profiles.active=dev


Swagger UI
=============

http://localhost:8084/api/static/index.html

Curl
=============

curl -i -X POST -H "Content-Type: multipart/form-data" -F "file=@raw_ocr.png" http://localhost:8083/api/info/smartkit/jreport/file/upload

Reference
=============

http://www.jaspersoft.com/reporting-software

