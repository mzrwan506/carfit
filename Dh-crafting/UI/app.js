let ReqItems = []
let ItemSelect = []
let LevelPlayer = null
let Inv = null
let InvStash = null
let k = null
$("body").hide();
$(document).ready(function () {
    $("body").on("keyup", function (key) {
        if (key.which === 113 || key.which == 27 || key.which == 90) {
            InvStash = null
            ReqItems = []
            ItemSelect = []
            LevelPlayer = null
            Inv = null
            k = null
            $.post(`https://${GetParentResourceName()}/CloseCraft`, JSON.stringify({}));
        }
    });
    window.addEventListener('message', (Event) => {
        if (Event.data.Action === "OpenCraft") {
            $("body").fadeIn();
            InvStash = Event.data.args
            Inv = Event.data.Inv
            $(".Crating-Items").empty();
            k = Event.data.K
            LevelPlayer = Event.data.LevelPlayer
            $("#Level-Number").html(Event.data.LevelPlayer)

            for (const [k, v] of Object.entries(Event.data.ItemsCrafts)) {
                if (v.level <= LevelPlayer) {
                    $(".Crating-Items").append(
                        `
                        
                        <div class="Crating-Item" data-dahm='${v.itemName}' data-label="${v.label}" data-level="${v.level}" data-time="${v.Timer}" data-amount="${v.amount}" data-price="${v.price}">
<div class="box-img-item">
<img src="nui://Rc2-inventory/html/images/${v.itemName}.png" alt="${v.label}">


                            </div>
<h4 class="Crafting-Item-Text">${v.label}</h4>
                        </div>
    
                        `)
                }
            }
            $(".Crating-Item").dblclick(function () {
                // $.post(`https://${GetParentResourceName()}/GetReqItem`, JSON.stringify({ Item: Item })).done((Data) => {
                //     ReqItems = Data
                // })
                // console.log()
                $.post(`https://${GetParentResourceName()}/StartCraft`, JSON.stringify({ ReqItems: ReqItems, SelectItem: ItemSelect[0].Item, InvStash: InvStash, K: k }));
            });
            $('.Crating-Item').click(function (e) {
                $('.Crafting-Info-Craft').css("display", "flex")
                if (ItemSelect[0] == undefined) {
                    ChangeInfoItem($(this).data('dahm'), $(this).data('label'), $(this).data('level'), $(this).data('time'), $(this).data('amount'), $(this).data('price'))
                } else {
                    ItemSelect.splice(0)
                    ChangeInfoItem($(this).data('dahm'), $(this).data('label'), $(this).data('level'), $(this).data('time'), $(this).data('amount'), $(this).data('price'))
                    // console.log(ItemSelect)
                }
            });
            
        } else if (Event.data.Action === 'CloseCraft') {
            $(".Crating-Items").empty();
            $("body").fadeOut();
            InvStash = null
            ReqItems = []
            ItemSelect = []
            LevelPlayer = null
            Inv = null
            k = null
        }
    })
});





function ChangeInfoItem(ITem, Label, Level, Time, Amount, Price) {
    ItemSelect.push({
        Item: ITem,
        Label: Label,
        Level: Level,
        Time: Time,
        Amount: Amount,
        Price: Price
    })
    $('.Price').html("$" + ItemSelect[0].Price)
    $('.Amount').html(ItemSelect[0].Amount + "x")
    $('.Time').html("00:" + ItemSelect[0].Time / 1000)
    $('.Level').html(ItemSelect[0].Level + ' <span>LVL</span>')
    $(".Info-Item-Header-Text").html(ItemSelect[0].Label);
    $(".Info-Item-Header-Text").html(ItemSelect[0].Label);
    $("#Info-Item-Header-Img").attr("src", `nui://${Inv}/html/images/${ItemSelect[0].Item}.png`);
    GetRequirements(ItemSelect[0].Item)
    // console.log(ItemSelect[0].Item)
}

function GetRequirements(Item) {
    $.post(`https://${GetParentResourceName()}/GetReqItem`, JSON.stringify({ Item: Item })).done((Data) => {
        $(".Info-Item-Req-Items").empty();
        ReqItems = Data
        // $(".Info-Item-Req").append(`
        //           <div class="Info-Item-Req-header">
        //                 <i class="fa-regular fa-calendar-days"></i>
        //                 <h3 class="Info-Item-Req-Header-Text"> Requirements </h3>
        //             </div>

        //     `);
        for (const [k, v] of Object.entries(Data)) {
            $(".Info-Item-Req-Items").append(
                `
  <div class="Info-Item-Req-Item">
                            <div class="Info-Item-Req-Item-First">
                                <h5 class="Info-Item-Req-Item-Amount-First">${v.Amount}x</h5>
                                <img src="nui://${Inv}/html/images/${v.Item}.png"
                                    class="Info-Item-Req-Item-Img-First">
                            </div>
                            <div class="Info-Item-Req-Item-Name">${v.Label}</div>
                        </div>
                `
            );
        }
    })
}