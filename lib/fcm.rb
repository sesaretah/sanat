module Fcm
   def send_fcm(user_ids, title, body, ntype, nid)
     @registration_ids = []
     for user_id in user_ids
       @device = Device.where(user_id: user_id).first
       if !@device.blank?
         if !@device.fcm_token.blank?
           @registration_ids << @device.fcm_token
         end
       end
     end

     @str = %q(curl -i -H 'Content-type: application/json' -H 'Authorization: key=AIzaSyAMwksNzuAgxp6Atl6XYDsCUR3fyn2itR4' -XPOST https://fcm.googleapis.com/fcm/send -d '{)
     @str = @str + %q("registration_ids":[) + @registration_ids.map(&:inspect).join(', ') + '],'
     @str = @str + %{"notification": {"sound" : "p.mp3","title": "#{title}","body":"#{body}"},"data": { "commentable_type" : "#{ntype}", "commentable_id" : "#{nid}"}}
     @str = @str + "}' &"
     #
     #puts @str
     system(@str)
   end
end
