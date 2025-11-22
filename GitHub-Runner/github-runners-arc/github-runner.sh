#!/bin/bash

printenv
 
az login --identity --username $MANAGED_IDENTITY_USER_ID
az acr login --name tfweucor207304
argocd relogin --password $ARGOCD_PASSWORD --insecure --grpc-web