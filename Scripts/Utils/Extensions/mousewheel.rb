
module Wheel

  extend self

  Get_Message=Win32API.new('User32','GetMessage','plll','l') # reception d'un message 

  Point=Struct.new(:x,:y) # crÃƒÂ©ation d'une structure de symboles: coord molette 
  Message=Struct.new(:message,:wparam,:lparam,:pt) # struct de symboles: message renvoyÃƒÂ© par la molette 
  Param=Struct.new(:x,:y,:scroll) # parametres de la molette 
  Scroll=0x0000020A # pointeur de la molette 

  def unpack_dword(buffer,offset=0) # dÃƒÂ©compactage d'integer 32bits 
    ret=buffer[offset+0]&0x000000ff 
    ret|=(buffer[offset+1] << (8*1))&0x0000ff00 
    ret|=(buffer[offset+2] << (8*2))&0x00ff0000 
    ret|=(buffer[offset+3] << (8*3))&0xff000000 
    return ret 
  end 
  def unpack_msg(buffer) # dÃƒÂ©compactage du message de la molette 
    msg=Message.new;msg.pt=Point.new 
    msg.message=unpack_dword(buffer,4*1) 
    msg.wparam=unpack_dword(buffer,4*2) 
    msg.lparam=unpack_dword(buffer,4*3) 
    msg.pt.x=unpack_dword(buffer,4*5) 
    msg.pt.y=unpack_dword(buffer,4*6) 
    return msg 
  end 
  def wmcallback(msg) 
    return unless msg.message==Scroll 
    param=Param.new 
    param.x=word2signed_short(loword(msg.lparam)) 
    param.y=word2signed_short(hiword(msg.lparam)) 
    param.scroll=word2signed_short(hiword(msg.wparam)) 
    return [param.x,param.y,param.scroll] 
  end 
  def hiword(dword);return ((dword&0xffff0000)>>16)&0x0000ffff;end # 
  def loword(dword);return dword&0x0000ffff;end 
  def word2signed_short(value) 
    return value if (value&0x8000)==0 
    return -1*((~value&0x7fff)+1) 
  end 

  def scroll # retourne l'etat de la molette 
    msg="\0"*32;Get_Message.call(msg,0,0,0);r=wmcallback(unpack_msg(msg)) 
    return r if !r.nil? 
  end 

end 