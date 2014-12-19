## docker

### Install : 

* install

		$ brew install docker boot2docker

* init 	VM

		$ boot2docker init
		$ boot2docker start
	
* Get container ip
		
		$ boot2docker ip	

### Add aliases :
function alias, add to ~/.bash_profile :
				
	function currentdir(){
        echo $(basename $(pwd)| awk '{print tolower($0)}')
	}
	
	function docker-name(){
        name=$(whoami)/$(currentdir)
        echo $name
	}
	function docker-run(){
        docker run -ti -d --privileged=true -v $(pwd):/data -i "$@" $(docker-name)
	}
	function docker-build() {
        docker build -t $(docker-name) .
	}
	function docker-id(){
        docker ps | grep $(docker-name) | awk '{ print $1 }'
	}
	function docker-stop(){
        docker stop $(docker-id)
	}
	function docker-attach(){
        docker attach $(docker-id)
	}
	function docker-ip(){
        echo $(boot2docker ip)
	}

### Build and run container

* build container : `$ docker-build`
* run container with port redirection: `$ docker-run -p 80:80 -p 3306:3306 -p 27017:27017`
* attach container (command line for the container) : `$ docker-attach` and `ctrl + c`

### Container informations
* application :
	* directory : /data/app
* nginx :
	* port : 80
* mysql :
	* user : hotplex/hotplex
	* db : hotplex
	* port : 3306
* mongodb 
	* db : hotplex 
	* port 27017



