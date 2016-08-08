# Customized_docker
Dockerfile which contains Oracle-Java, Python Pip and pyang package, Maven 3.0.3, Apache Tomcat 7.0.70

Order of execution

Go inside postgresDB folder and execute

1) docker build -t postgresapp .
2) docker run -t --name postgresappc postgresapp

Go inside the MongoDB folder and execute

 1) docker build -t mongoapp .
 2) docker run -t --name mongoappc mongoapp
 
 make sure they both are started by executing docker ps command
  
   docker ps 
   
 Then install docker-compose if you don't have it earlier 
 
 come to main directory where .yaml file is present and execute 
 
    1) docker-compose up
    
  You can you above docker files to any project which required following services 
   1) Oracle Java
   2) Postgress DB
   3) Mongo DB
   4) Tomcat server
   
   Please put .yaml and Dockerfile inside the main pom.xml, then build and start the docker  
  
