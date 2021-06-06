local jshapes = {}


-------------------------------------------------------
-------------------- Functions ------------------------
-------------------------------------------------------


----------------------------------------------------
-- rotate v1 to v2
function jshapes.rotvec(v1,v2)
    local rvec=cross(v1,v2)
    -- if v1 and v2 parallel, get any perpendicular vector.
    if (length(rvec)==0) then 
      rvec=cross(v1,normalize(v(1,2,5)))
    end
    return rvec
  end
  ----------------------------------------------------
  
  ----------------------------------------------------
  -- rotate v1 to v2
  function jshapes.rotangle(v1,v2)
    local angle = math.acos( dot(v1,v2) )*180/3.141592654 
    local vc = jshapes.rotvec(v1,v2)
    local vrot=rotate(angle,vc)*v1
    local vrot2=rotate(angle+180,vc)*v1
    if (length(vrot-v2)>length(vrot2-v2)) then
      angle=angle+180
    end
    return angle
  end
  ----------------------------------------------------
  
  ----------------------------------------------------
  -- get rotation matrix to rotate v1 to v2
  function jshapes.rotationmatrix(v1,v2)
     local v1n=normalize(v1)
     local v2n=normalize(v2)
     local rv = jshapes.rotvec(v1n,v2n)
     local ra = jshapes.rotangle(v1n,v2n)
  
     return rotate(ra,rv)
  end
  ----------------------------------------------------
  
  ----------------------------------------------------
  function jshapes.nutshape(ndepth)
  -- nyloc nuts were very tight at 4mm radius, cracking the plastic, so add a little (+0.1mm)
  local r=4.1
  local rx=r/2
  local ry=0.866025*r
  local nut={ v{r,0,0},v{rx,ry,0},v{-rx,ry,0},v{-r,0,0},v{-rx,-ry,0},v{rx,-ry,0}}
  local nuthole=linear_extrude(v(0,0,ndepth),nut)
  return nuthole
  end
  ----------------------------------------------------
  
  
  ----------------------------------------------------
  -- create m4 recess. nyloc=true for nyloc nut.
  -- screw head at vstart, nut at vend
  local function _m4r(vstart,vend,boltlength,isnyloc)
  local headr=7/2
  local headdepth=2.5
  local shaftr=4/2
  local holelength=length(vend-vstart)
  local s=cylinder(shaftr,math.max(holelength,boltlength+headdepth))
  
  headdepth=math.max(headdepth,holelength-boltlength)
  local h=cylinder(headr,headdepth)
  
  local b=union(s,h)
  
  local ndepth=3
  if (isnyloc) then ndepth=5 end
  local nuthole=jshapes.nutshape(ndepth)
  nuthole=translate(0,0,holelength-ndepth)*nuthole
  
  local assembly=union(b,nuthole)
  
  -- vstart at 0,0,0 currently. Rotate and position.
  avec=v(0,0,1)
  assembly=jshapes.rotationmatrix(avec,vend-vstart)*assembly
  assembly=translate(vstart)*assembly
  return assembly
  end

  function jshapes.m4r(vstart,vend,boltlength)
    return _m4r(vstart,vend,boltlength,3)
  end

  function jshapes.m4rn(vstart,vend,boltlength)
    return _m4r(vstart,vend,boltlength,5)
  end
  ----------------------------------------------------


  ----------------------------------------------------
  -- Ziptie hole. 
  function jshapes.ziptie(vstart,vend,w,l)
    local d=length(vend-vstart)
    ziphole=cube(w,l,d)
    avec=v(0,0,1)
    ziphole=jshapes.rotationmatrix(avec,vend-vstart)*ziphole
    ziphole=translate(vstart)*ziphole
    return ziphole
  end
  -- for standard small zipties.
  function jshapes.ziptiew(vstart,vend)
    return jshapes.ziptie(vstart,vend,4,2)
  end
  function jshapes.ziptiel(vstart,vend)
    return jshapes.ziptie(vstart,vend,2,4)
  end
  ----------------------------------------------------   

return jshapes
