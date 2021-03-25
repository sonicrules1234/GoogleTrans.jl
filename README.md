# GoogleTrans.jl
Example :

using GoogleTrans
message = "Hello."
target_language = "ja" # Japanese
translation = GoogleTrans.translate(message, target_language)
