var totalCost = 0
window.addEventListener('message', function(event){
    const item = event.data 
    if (item.type == "open") {
        $(".rectangle_1").css("display", "block").animate({ left: "664px" }, 200).fadeIn();
        $(".grid-container").show();
        $(".basketbtn").show();
        $(".close").show();

        if (item.letype == "24") {
            $(".img-type").attr("src","images/24.png");
        
            document.querySelectorAll(".lebouttonadd").forEach(function(a){a.style.background='#006B57'})
        } else if (item.letype == "ltd") {
            $(".img-type").attr("src","images/shopui_title_gasstation.png");
            document.querySelectorAll(".lebouttonadd").forEach(function(a){a.style.background='#262A5A'})
            
        }
        
    }
    if(item.type === 'addItem') {
        $("#basket").hide()
        $('.bankbtn').hide()
        $(".cashbtn").hide()
        $(".fleche-back").hide()
        $(".totaldupanier").hide()
        div = `<div class="item1">
            <img src="images/`+item.name+`.png" alt="">
            <button class="lebouttonadd"onclick="addBasket('`+item.name+`', '`+item.label+`')">`+item.label+`</button>
        </div>`
        $(".grid-container").append(div)
    }
    if (item.type === "removeAmount") {
       
        var quantityElement = document.getElementById(item.label);
        var totalcostp = document.getElementById("totalcost_"+item.name);
        var totalcost = document.getElementById("totaldupanier");
        if (quantityElement) {
            if (item.amount > 0) {
                quantityElement.innerHTML =item.amount;
                totalcostp.innerHTML = item.total + " $";
                totalCost = totalCost-item.price;
                totalcost.innerHTML = "Total : " + totalCost+"$"
            } else { 

                var itemz = document.getElementById(item.name);
                itemz.remove()

            }
            
        }
    }
    if (item.type == "removeItem") {
        document.getElementById(item.name).remove()
    }
    if (item.type === "addList") {
        var quantityElement = document.getElementById(item.label);
        var totalcostp = document.getElementById("totalcost_"+item.name);
        var totalcost = document.getElementById("totaldupanier");

        totalCost = totalCost + item.price
        if (quantityElement) {
            if (item.amount > 1) {
                quantityElement.innerHTML = item.amount;
                totalcostp.innerHTML = item.total  + " $";
                totalcost.innerHTML = "Total : " + totalCost+"$"
               
            } 
        
        } else {
            var listItem = `
                <div class="Item-basket-container" id="`+item.name+`">
                    <img src="images/`+item.name+`.png" alt="">
                    <button class="deletebtn" onclick="deleteItem('`+item.name+`', '`+item.label+`')"><i class="fa fa-trash" ></i></button>
                    <a class="totaldelitemprix" id="totalcost_`+item.name+`">${item.total} $</a>
                    <div class="bite">
                        <p class="labelitembasket">${item.label}</p>
                        <div class="counter">
                            <button id="btnplus" onclick="addBasket('`+item.name+`', '`+item.label+`')">+</button>
                            <p class="montant" id="`+item.label+`">${item.amount}</p>
                            <button id="btnmoins" onclick="removeAmount('`+item.name+`', '`+item.label+`')">-</button>
                        </div>
                    </div>
                    
                </div>`;
            $("#basket").append(listItem);
            
            
        }
      
    }
   
    if (item.type == "close") {
        exit()
    }
   

})
function addBasket(item,label) {
    $.post('https://uiShop/addBasket', JSON.stringify ({
        name: item,
        label:label
    }));
}
function removeAmount(item,label) {
    $.post('https://uiShop/removeAmount', JSON.stringify ({
        name: item,
        label:label
    }));
}
function deleteItem(item,label) {
  $.post('https://uiShop/deleteItem', JSON.stringify ({
    name: item,
    label:label
}));
}

function backtohome() {
    $(".totaldupanier").hide()
    $(".grid-container-back").hide()
    $(".basketbtn").show()
    $(".grid-container").show()
    $("#basket").hide()
    $('.bankbtn').hide()
    $(".cashbtn").hide()
    $(".fleche-back").hide()
    $(".close").show()
}


function loadBasket(){
    $(".basketbtn").hide()
    $(".grid-container").hide()
    $(".close").hide()
    $("#basket").show()
    $('.bankbtn').show()
    $(".cashbtn").show()
    $(".fleche-back").show()
    $(".totaldupanier").show()
}
function formatBalance(balance) {
  var formatter = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    });
 return formatter.format(balance)   
}
function exit() {
    totalCost = 0
    $(".rectangle_1").animate({ left: "-500px" }, 200).fadeOut();
    setTimeout(function(){
        document.querySelectorAll(".item1").forEach(function(a){a.remove()})
        document.querySelectorAll(".Item-basket-container").forEach(function(a){a.remove()})
         
    }, 300);
    $.post('https://uiShop/exit', JSON.stringify({}));
    totalCost = 0
}

function buy(lamethod) {
    $.post('https://uiShop/buy', JSON.stringify ({
      cout: totalCost,
      method: lamethod
    }));
    
}

  
$(document).ready(function () {
    $(".rectangle1").on("keyup", function (key) {
      if (Config.closeKeys.includes(key.which)) {
        exit();
      }
    });
})