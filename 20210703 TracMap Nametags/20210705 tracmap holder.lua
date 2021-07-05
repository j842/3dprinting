-- holder for nametags.

package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags2=require("jtags2")

hold=jtags2.holder()
  --hold=jshapes.xycenter(rotate(90,X)*hold)
  emit(hold)

