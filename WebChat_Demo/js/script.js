//Get timestamp
function formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
}
//Runs each time message refreshes
var renew = function() {
    var api_url = 'https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/f111b7428d4a0f9d4d050e668e42edc63568c784c21a81c9251e143b2bfb36a0/powerful/powerful',
	l=$(".msj,.msj-rta").length/2;
    $(".msj,.msj-rta").each(function(i) {
        if ($(this).find(".fa-search").attr('data-content') == '') {
            $(this).find(".fa-search").attr('data-content', 'Loading...');
            var text = $(this).find('p:first-of-type').text();
            var pthis = this;
            $.ajax({
                url: api_url,
                data: {
                    'text': '"' + text + '"',
                    'type': 'Emotion'
                },
                dataType: 'json',
                success: function(data) {
                    var info = '';
                    var emotion = 'joy';
                    for (var emo in data) {
                        if (data[emo] > data[emotion]) {
                            emotion = emo;
                        }
                    }
                    info += 'Emotion: ' + emotion;
					if(i>=l){
						if ($(pthis).hasClass("msj"))
							$(".input-r").css("background-color",inputcolor[emotion]);
						else $(".input-l").css("background-color",inputcolor[emotion]);
					}
                    $.ajax({
                        url: api_url,
                        data: {
                            'text': '"' + text + '"',
                            'type': 'Entities'
                        },
                        dataType: 'json',
                        success: function(data) {
                            if (!('NULL' in data)) {
                                info += '<br/><br/>';
                                for (var entity in data) {
                                    info += entity + ':<p class="entityinfo">' + data[entity] + '</p>';
                                }
                            }
                            $(pthis).find(".fa-search").attr('data-content', info);
                        }
                    });
                },
                error: function() {
                    $(pthis).find(".fa-search").attr('data-content', "Sorry, we can't analyze");
                }
            });
        }
        $(function() {
            $('[data-toggle="popover"]').popover()
        });
        $(this).hover(function() {
            $(this).find('.fa-search').show('fast', function() {
                $(this).css('display', 'inline-block');
            });
        }, function() {
            $(this).find('.fa-search').hide('fast');
        });
    });
};
//Inser new message into chatroom
function insertChat(who, text, time = 0) {
    var date = formatAMPM(new Date());
    var control_left = '';
    var control_right = '';
    control_left = '<li style="width:100%">' +
        '<div class="msj">' + '<div class="avatar-left"><img src="img/' + who + '.png" width="40" height="40"/></div>' + '<div class="macro text text-l">' +
        '<p>' + text + '</p>' +
        '<p><small>' + date + '</small></p>' +
        '</div>' + '<div class="space"><i class="fa fa-search" data-toggle="popover" data-trigger="hover" data-html="true" data-placement="right" data-content="" aria-hidden="true"></i></div>' +
        '</div>' +
        '</li>';
    control_right = '<li style="width:100%;">' +
        '<div class="msj-rta">' + '<div class="space"><i class="fa fa-search" data-toggle="popover" data-trigger="hover" data-html="true" data-placement="left" data-content="" aria-hidden="true"></i></div>' +
        '<div class="macro text text-r">' +
        '<p>' + text + '</p>' +
        '<p><small>' + date + '</small></p>' + '</div>' + '<div class="avatar-right"><img src="img/' + who + '.png" width="40" height="40"/></div>' +
        '</div>' +
        '</li>';

    setTimeout(
        function() {
            if (who == 'left') {
                $("#left").children("ul").animate({
                    opacity: 0
                }, 200, function() {
                    $(this).append(control_right).animate({
                        opacity: 1
                    }, 300);
                    //renew();
                })
                $("#right").children("ul").animate({
                    opacity: 0
                }, 200, function() {
                    $(this).append(control_left).animate({
                        opacity: 1
                    }, 300);
                    renew();
					$("ul").scrollTop(1<<30);
                })
            } else {
                $("#right").children("ul").animate({
                    opacity: 0
                }, 200, function() {
                    $(this).append(control_right).animate({
                        opacity: 1
                    }, 300);
                    //renew();
                })
                $("#left").children("ul").animate({
                    opacity: 0
                }, 200, function() {
                    $(this).append(control_left).animate({
                        opacity: 1
                    }, 300);
                    renew();
					$("ul").scrollTop(1<<30);
                })
            }
		
        }, time);
}

function resetChat() {
    $("ul").empty();
}
/*        $("textarea").on("keyup", function(e){
            if (e.keyCode == 13){
                var text = $(this).val();
                var who = $(this).parents('div .frame').attr('id');
                if (text !== ""){
                    insertChat(who, text);
                    $(this).val('');
                }
            }
        });*/
$(".send").click(function() {
    var text = $(this).siblings('textarea').val();
    var who = $(this).parents('div .frame').attr('id');
    if (text != "") {
        insertChat(who, text);
        $(this).siblings('textarea').val('');
    }
});

var inputcolor={
	joy:"#ffcc00",
	anger:"red",
	fear:"purple",
	sadness:"blue",
	disgust:"green"
},
h=$(".frame").height()-$(".bar").height()-$(".inputarea").height();
$("ul").height(h);
//Clear Chat
resetChat();
insertChat("left", "Messi is way more better than Ronaldo", 100);
insertChat("right", "I don't think so", 1000);
