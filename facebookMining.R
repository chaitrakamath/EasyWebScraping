#install required packages
library(Rfacebook)

#this access token expires every one hour or so. So, make sure to update your token
access_token <- 'CAACEdEose0cBACq2gxOKOIGD2lklBYibceag7YrWEfvtzoOYT4FQd80Hb3ufpzu3hdHEzY1oYf04an8wII7m13fbuDnaIK5yVKTjHsM1I4kzZA4VDsFsm7K33wwuDXmIj8CfBhjQ6ZCIRT3CtEwbSAQbSe84OYlTknD6QePIQb4kCLeHtYaGd1LsDOzHZAx1Rb6fvYrjQZDZD'

#get your information
my_profile <- getUsers('me', token = access_token)
print(my_profile)

#since api v2.0, getFriends() will only access those friends that are registered on developers.facebook.com
my_friends <- getFriends(token = access_token, simplify = FALSE)
print(my_friends)

#plot network of my friends
library(igraph)
my_network <- getNetwork(access_token, format = 'adj.matrix')
network_graph <- graph.adjacency(my_network, mode = 'undirected')

plot(network_graph, edge.curved = TRUE, edge.color = rainbow(50), edge.width = 6)

