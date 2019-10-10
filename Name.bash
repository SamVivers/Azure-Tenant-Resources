AccountName=`az account list --query [].user.name -o tsv`
echo $AccountName
for (( i=0; i<${#AccountName}; i++ )); do
        if [ "${AccountName:i:1}" == "@" ]; then
                EmailName="${AccountName:i+1:${#AccountName}}"
	fi
done
for (( i=0; i<${#EmailName}; i++ )); do
        if [ "${EmailName:i:3}" == ".co" ]; then
                UserName="${EmailName:0:i}"
        fi
done
UserId=`az account list --query [].id -o tsv`
ContainerName="$UserId ($UserName)"
echo $ContainerName
