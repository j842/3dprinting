-- test of nametag code.
package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

n = jshapes.nametag('Awesome Jack',10,3,100)
emit(n)

