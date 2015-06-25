# =begin
# #===============================================================================
#  Title: Map Screenshot
#  Author: Hime
#  Date: Dec 7, 2014
# --------------------------------------------------------------------------------
#  ** Change log
#  Dec 7, 2014
#    - added option to draw certain events
#  Apr 15, 2013
#    - updated script to use GDI+ interface
#    - added support for region map overlay and passage map overlay
#  Apr 6, 2013
#    - fixed bug where drawing events crashed the game
#  Apr 2, 2013
#    - map data is now setup by an instance of Game_Map, to account for custom
#      map scripts adding to the map
#  Jul 27
#    - Export dirNames are now optional
#  May 28
#    - updated overlay mapping compatibility to draw the overlays 
#      based on the player's current position
#    - fixed issue where import hash was commented out
#    - Added support for Yami's overlay mapping
#  May 24, 2012
#    - fixed large characters
#    - some optimizations for calculating bounds and dimensions
#  May 5, 2012
#    - fixed waterfall autotile
#    - added screenshot feature
#  May 4, 2012
#    - fixed tiles with alpha channel
#    - fixed shadows
#    - fixed wall autotiles
#  May 1, 2012
#    - fixed wall autotile, although there is still an issue with some tiles
#  Apr 29, 2012
#    - fixed shadow map drawing
#    - added region highlighting
#    - added damage tile highlighting
#  Apr 28, 2012
#    - Initial Release
# ------------------------------------------------------------------------------
#  ** Description
 
#  This script allows you to take a full image of any of your game's maps
#  and export. An image of the map is referred to as a "mapshot" (as opposed to
#  screenshot).
 
#  The script provides various configuration options to control what kinds of
#  things you want to see on your map, such as events, vehicles, region ID's, or
#  specific tile properties.
 
# ------------------------------------------------------------------------------
#  ** Usage
 
#  The default key for taking a mapshot is F7. This can be changed in the
#  configuration section.
 
#  To take a mapshot, first start the game, and then hit F7.
#  A message will appear informing you that a mapshot was successfully taken.
 
#  Alternatively, you can use script calls to take mapshots.

#     Map_Saver.new(map_id).export
    
#  Aside from exporting images, you are able to use the image that the
#  map saver captures.
 
#    ms = Map_Saver.new(map_id)
#    bmp = ms.map_image
   
#  This gives you a reference to a Bitmap object that contains an image of
#  your map.
# --------------------------------------------------------------------------------
#   ** Credits
 
#   Cremno
#     -GDI+ interface code

# ================================================================================
# =end

# # ★ GDI+ interface
# # ★★★★★★★★★★★★
# #
# # Author : Cremno
# #
 
# module Gdiplus

#   DLL = 'gdiplus.dll'
 
#     GdiplusStartup = Win32API.new(DLL,'GdiplusStartup', 'PPP','L')

#     GdiplusShutdown = Win32API.new(DLL,'GdiplusShutdown', 'P', 'V')

#     GdipDisposeImage = Win32API.new(DLL,'GdipDisposeImage', 'P','L')
#     GdipSaveImageToFile = Win32API.new(DLL,'GdipSaveImageToFile', 'PPPP','L')
#     GdipCreateBitmapFromGdiDib = Win32API.new(DLL,'GdipCreateBitmapFromGdiDib', 'LLP','L')
#     GdipCreateBitmapFromHBITMAP = Win32API.new(DLL,'GdipCreateBitmapFromHBITMAP', 'LLP','L')
#     GdipCreateBitmapFromScan0 = Win32API.new(DLL,'GdipCreateBitmapFromScan0', 'LLLLPP','L')

 
#   @@token = [0].pack('I')
#   def self.token
#     @@token
#   end
 
#   @@clsids = {}
#   def self.clsids
#     @@clsids
#   end
 
#   def self.gen_clsids
#     return unless @@clsids.empty?
#     func = Win32API.new('rpcrt4.dll', 'UuidFromString', 'PP', 'L')
#     {
#       :bmp =>  '557cf400-1a04-11d3-9a73-0000f81ef32e',
#       :jpeg => '557cf401-1a04-11d3-9a73-0000f81ef32e',
#       :gif =>  '557cf402-1a04-11d3-9a73-0000f81ef32e',
#       :tiff => '557cf405-1a04-11d3-9a73-0000f81ef32e',
#       :png =>  '557cf406-1a04-11d3-9a73-0000f81ef32e'
#     }.each_pair do |k, v|
#       clsid = [0].pack('I')
#       func.call(v, clsid)
#       @@clsids[k] = clsid
#     end
#     @@clsids[:jpg] = @@clsids[:jpeg]
#     @@clsids[:tif] = @@clsids[:tiff]
#   end
 
#   # TODO: prepend prefix (Gdip or Gdiplus) automatically
#   # def self.call(*args)
#   #   name = args.shift
#   #   func = FUNCTIONS[name]
#   #   v = func.call(*args)
#   #   if v && v != 0
#   #     msgbox "GDI+ error: #{v}\n\nFunction: #{name}\nArguments: #{args.inspect}"
#   #     false
#   #   else
#   #     true
#   #   end
#   # end
 
#   def self.startup
#     GdiplusStartup.call( @@token, [1, 0, 0, 0].pack('L4'), 0)
#   end
 
#   def self.shutdown
#     GdiplusShutdown.call(@@token)
#   end
 
#   class Image
 
#     attr_reader :instance
#     def initialize
#       @instance = 0
#       true
#     end
 
#     def save(destination, *args)
#       case destination
#       when :file
#         filename = args.shift << "\0"
#         filename.encode!('UTF-16LE')
#         argv = [:GdipSaveImageToFile, filename, Gdiplus.clsids[args.shift], 0]
#       else
#         raise ArgumentError, "unknown GDI+ image destination: #{source}"
#       end
#       argv.insert(1, @instance)
#       Gdiplus.call(*argv)
#     end
 
#     def dispose
#       Gdiplus.call :GdipDisposeImage, @instance
#     end
#   end
 
#   class Bitmap < Image
 
#     def initialize source, *args
#       case source
#         when :gdidib
#           argv = [:GdipCreateBitmapFromGdiDib, args.shift, args.shift]
#         when :hbitmap
#           argv = [:GdipCreateBitmapFromHBITMAP, args.shift, 0]
#         when :scan0
#           w = args.shift
#           h = args.shift
#           argv = [:GdipCreateBitmapFromScan0, w, h, w * -4, 0x26200a, args.shift]
#         else
#           raise ArgumentError, "unknown GDI+ bitmap source: #{source}"
#       end
#       argv.push([0].pack('I'))
#       retval = Gdiplus.call(*argv)
#       @instance = retval ? argv.last.unpack('I').first : 0
#       retval
#     end
#   end

# end


# class Bitmap
 
#   def save(filename, options = {})
#     options.merge!(:format => File.extname(filename)[1..-1].to_sym)
#     retval = false
#     #bitmap = Gdiplus::Bitmap.new(:hbitmap, hbitmap)
#     #bitmap = Gdiplus::Bitmap.new(:gdidib, *gdidib)
#     # this seems to be the fastest one (RGSS 3.0.1, Windows 8 64-bit)
#     bitmap = Gdiplus::Bitmap.new(:scan0, width, height, scan0)
#     if bitmap
#       retval = bitmap.save(:file, filename, options[:format])
#       bitmap.dispose
#     end
#     retval
#   end
 
# private
 
#   def _data_struct(offset = 0)
#     @_data_struct ||= (DL::CPtr.new((object_id << 1) + 16).ptr + 8).ptr
#     (@_data_struct + offset).ptr.to_i
#   end
 
#   def gdidib
#      [_data_struct(8), _data_struct(16)]
#   end
 
#   def hbitmap
#     _data_struct(44)
#   end
 
#   def scan0
#     _data_struct(12)
#   end
 
# end

# Gdiplus.startup
# Gdiplus.gen_clsids
 
# # if Gdiplus.startup
# #   Gdiplus.gen_clsids
# #   class << SceneManager
# #     alias_method :run_wo_gdip_shutdown, :run
# #     def run
# #       run_wo_gdip_shutdown
# #       Gdiplus.shutdown
# #     end
# #   end
# # end