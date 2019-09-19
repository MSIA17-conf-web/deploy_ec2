def terraform_url = "https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip?_ga=2.246224583.277258223.1516982221-1601534939.1510064976"
def terraform_zip_path= "./terraform.zip"

pipeline {

    agent any

    parameters {
        booleanParam(name: 'Refresh', defaultValue: false, description: 'Read Jenkinsfile and exit.')
        choice(choices: ['CREATE', 'DESTROY'], description: 'Create a EC2 instance or destroy one?', name: 'Action')
        string(description: 'Create a deployment ID. You will need this later to destroy instances.', name: 'deploymentID', defaultValue: 'neito-ec2')
        choice(choices: ['yes', 'no'], name: 'destroyAtStart', description: 'if CREATE, do you want to destroy previous instance with the given deploymentID first ?')
        string(description: 'Pick the size of the EC2 instance', name: 'EC2Size', defaultValue: 't2.micro')
    }

    environment {
        PATH = "${workspace}:$PATH"
        aws_secret_id = credentials("aws_secret_id")
        aws_secret_key = credentials("aws_secret_key")

    }

    stages {
        stage('Read Jenkinsfile') {
            when { expression { return params.Refresh == true } }
            steps { echo("Read Jenkinsfile to refresh properties.") }
        }

        stage('Run Jenkinsfile') {
            when { expression { return params.Refresh == false } }
            stages { 
                stage ('Install deployment tools (terraform)') { 
                    steps { 
                        sh "pwd"
                        print "Install terraform version 0.11.2"
                        sh "wget -q -O ${terraform_zip_path} ${terraform_url}"
                        sh "unzip -o ${terraform_zip_path}" 
                    }
                }

                stage('init terraform ') {   
                    steps {
                        dir("${workspace}"){
                            sh "ls && pwd"
                            sh """
                            terraform init \
                            -backend-config="region=us-east-2" \
                            -backend-config="aws_secret_id=${env.aws_secret_id}" \
                            -backend-config="aws_secret_key=${env.aws_secret_key}" 
                            """      
                        }
                    }
                }

                stage('Destroy') {
                    when { equals expected: "DESTROY", actual: "${params.Action}" }
                    steps {
                        dir("${workspace}"){
                            sh """
                                terraform destroy \
                                -force \
                                -var "EC2Size=${params.EC2Size}" \
                                -var "deploymentID=${params.deploymentID}" \
                                -var "aws_secret_id=${env.aws_secret_id}" \
                                -var "aws_secret_key=${env.aws_secret_key}"
                            """      
                        }
                    }
                }

                stage('Destroy at start') {
                    when { equals expected: "yes", actual: "${params.destroyAtStart}" }
                    steps {
                        dir("${workspace}"){
                            sh """
                                terraform destroy \
                                -force \
                                -var "EC2Size=${params.EC2Size}" \
                                -var "deploymentID=${params.deploymentID}" \
                                -var "aws_secret_id=${env.aws_secret_id}" \
                                -var "aws_secret_key=${env.aws_secret_key}"
                            """      
                        }
                    }
                }

                stage('Create') {
                    when{ equals expected: "CREATE", actual: "${params.Action}"}
                    steps {
                        dir("${workspace}"){
                            sh """
                                terraform apply \
                                -auto-approve \
                                -var "EC2Size=${params.EC2Size}" \
                                -var "deploymentID=${params.deploymentID}" \
                                -var "aws_secret_id=${env.aws_secret_id}" \
                                -var "aws_secret_key=${env.aws_secret_key}"
                            """
                        }
                    }
                }
            }
        }
    }
}