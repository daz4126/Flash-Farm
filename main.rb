require 'sinatra'
require 'slim'
require 'sinatra/flash'

enable :sessions

get '/' do
  slim :index
end

post '/time' do
  flash[:time] = Time.now.strftime("%I:%M:%S")
  redirect '/'
end

post '/buy/:animal' do
  animal = params[:animal]
  #code that adds an animal to the shopping basket goes here
  flash[:success] = "A #{animal} was successfully added to your basket"
  flash[:warning] = "Warning! Buying too many ducks can drive you quackers" if animal == 'duck'
  redirect to('/')
end

post '/checkout' do
  n = rand(3)
  flash[:error] = "There was an error processing your payment" if n == 0
  flash[:success] = "Your payment was successful" if n > 0
  redirect to('/discount') if n == 2
  redirect to('/finish')
end

get '/discount' do
  flash.keep
  # discount logic goes here
  flash[:info] = "A discount of 10% was applied to your order"
  redirect to('/finish')
end

get '/finish' do
  flash.now[:message] = "Thank you for shopping at Flash Farm, please come baaa-ck soon!"
  slim :index
end

get '/styles.css' do
 scss :styles
end

__END__

@@layout
doctype html
html
  head
    meta charset="utf-8"
    title Sinatra Flash
    link rel="shortcut icon" href="/favicon.ico"
    link rel="stylesheet" media="screen, projection" href="/styles.css"
  body
    == styled_flash
    == yield


@@index
h1 Flash Farm Shop!
p Choose which animals you would like to buy from our shop.
ul#animals
  li
    h2 Duck
    img src="/duck.png"
    form action="/buy/duck" method="POST"
      input type="submit" value="Add to Basket" title="Buy me, quack!"
  li
    h2 Pig
    img src="/pig.png"
    form action="/buy/pig" method="POST"
      input type="submit" value="Add to Basket" title="Buy me, oink!"
  li
    h2 Cow
    img src="/cow.png"
    form action="/buy/cow" method="POST"
      input type="submit" value="Add to Basket" title="Buy me, moo!"
form action="/checkout" method="POST"
  input type="submit" value="Checkout" title="Checkout"

@@styles
body{font:13px sans-serif;}

h1{
  color: #330080;
}
h2{
  color: #aa0044;
  margin:0;
}
.flash{
  width: 600px;
  padding: 5px;
  font-weight: bold;
  margin: 20px;
  background:#ddd;
  color:#666;
  border:1px solid #ccc;
}

.info{
  background:#D9EDF7;
  color:#3A87AD;
  border:1px solid #BCE8F1;
}
.warning{
  background:#FCF8E3;
  color:#C09853;
  border:1px solid #FBEED5;
}
.success{
  background:#DFF0D8;
  color:#468847;
  border:1px solid #D6E9C6;
}
.error{
  background:#F2DEDE;
  color:#B94A48;
  border:1px solid #EED3D7;
}
#animals{
  overflow: hidden;
  padding:0;
  li{
    float:left;
    list-style:none;
    margin: 0 10px 0 0;
    img{
      border: #330080 solid 3px;
    }
  }
}
