Como rodar o Container

docker run -it --name teste -v <Diretorio onde estarão as Jobs>:/jobs -v <Diretorio de saida de arquivos processados>:/fs <Imagem do pentaho contruida> <comando para execução> <Nome do arquivos da job>

Exemplo de Execução de Job

    docker run -it --name teste -v /home/sandro/teste:/jobs -v /home/sandro/teste2:/fs pentaho-pdi:latest runj teste.kjb


Exemplo de Execução de Transformatiom

    docker run -it --name teste -v /home/sandro/teste:/jobs -v /home/sandro/teste2:/fs pentaho-pdi:latest runj teste.ktr


Exemplo de Execução do Spoon
   
    docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
	-v $1:/jobs \
	-v $2:/output \
	-e START_MEN=1024m \
	-e MAX_MEN=4096m \
	-e XAUTH=$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
	--memory=$MAX_MEN --name spoon pentaho-pdi spoon

    OBS: 
        - Tenha certeza de estar com a imagem do pentaho criada em suas imagens com o nome de pentaho-pdi ou usando a imagem sandro3000/pentaho-pdi
            - Caso necessite buildar a imagem dentro no git https://github.com/raidons/pentaho-pdi esta a disposição os arquivos necessários para build da imagem do Pentaho 
        - Dentro do spoon valide a quantidade de memoria do START_MEN e do MAX_MEN para se adequar a sua necessidade
        - Dentro do diretório jobs adicione os seguintes arquivos kettle.properties e jdbc.properties e edite estes conforme seu ambiente
        