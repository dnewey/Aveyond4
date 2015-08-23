#==============================================================================
# ** SpellCheck
#==============================================================================

def execute_spellcheck
    
    data = {} # map name, dialogues?
    
    # Each map
    $data.mapinfos.each{ |k,v| 
    
      map_id = k
      map_name = v.name
      
      event_list = load_data(sprintf("Data/Map%03d.rxdata",map_id)).events
      next if event_list.empty?
      
      events = {}
      
      # Do for each event
      event_list.each{ |k,v|
      
        ev_id = k
        ev_name = v.name
        
        dialogues = []
        
        # Do for each page
        v.pages.each{ |page|
        
        @cmd_idx = 0        
        while page.list[@cmd_idx] do

            # Do something according to command          
            case page.list[@cmd_idx].code
            
              when 101; # Short text
                
                text = page.list[@cmd_idx].parameters[0]
                while page.list[@cmd_idx+1].code == 401       # Text data
                  @cmd_idx += 1
                  text += page.list[@cmd_idx].parameters[0]
                  text += ' '      
                end
                dialogues.push(text)
            
            end
              
            @cmd_idx += 1  
          
          end # page        
        
        }

        # any dialogues? save it
        if !dialogues.empty?
          #p dialogues
          events[[ev_id,ev_name]] = dialogues
        end
        
      }

      # Add to overall
      if !events.empty?
        data[[map_id,map_name]] = events
      end
      
      #p name
      #p event_list.size
      
      
      #break
      
      
    }
    
    # Output to file
    # Create a new file and write to it  
    File.open('spellcheck.txt', 'w') do |file|  

      # Write some stats
      file.puts("Total Maps: "+$data.mapinfos.size.to_s)
      file.puts("Maps with dialogue: "+data.size.to_s)

      # Word counts
      words = 0
      data.values.each{ |map|
        map.values.each{ |ev|
          ev.each{ |line|
            words += line.split(" ").size
          }
        }
      }
      file.puts("Word Count: "+words.to_s)

      file.puts("\n")
      file.puts("\n")

      # Each Map
      data.each{ |mk,mv|

        # Map name
        file.puts("Map "+mk[0].to_s+": "+mk[1])
        file.puts("----------------------------------------")
        file.puts("\n")

        # Contents
        mv.each{ |ek,ev|

          # Event name
          file.puts("Event "+ek[0].to_s+": "+ek[1])

          # Event contents
          ev.each{ |line|
            file.puts(line)
          }

          file.puts("\n")

        }
        file.puts("\n")
      }

    end  

    
  end