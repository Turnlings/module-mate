'use strict'
import {FetchRequest} from "@rails/request.js";

let rotationValue = [0,0,0,0];
function get_and_set_countdown_timer(){
    let containers = document.getElementsByClassName("countdown-container");
    if(containers.length > 0){
        let countdown = containers[0];
        let href = window.location.href+".json";
        //href = href.replace("http", "").replace("https", "");
        console.log(href);
        get_due_time(href).then(r => {
            setInterval(update_counter, 1000, countdown, r);
            console.log(r);
        });

    }
}
function update_counter(countdownContainer, due_time){
    let now = Date.now()
    let diffTime = (due_time-now)/1000;

    let seconds = 0;
    let minutes = 0;
    let hours = 0;
    let days = 0;
    if(diffTime >= 0){
        const divmod = (x, y) => [Math.floor(x / y), x % y];
        [minutes, seconds] = divmod(diffTime,60);
        [hours, minutes] = divmod(minutes, 60);
        [days, hours] = divmod(hours, 24);
        seconds = Math.round(seconds);
    }
    //countdownContainer.childNodes[1].childNodes[1].innerText = days;
    //countdownContainer.childNodes[3].childNodes[1].innerText = hours;
    //countdownContainer.childNodes[5].childNodes[1].innerText = minutes;
    //countdownContainer.childNodes[7].childNodes[1].innerText = seconds;
    update_sub_counter(1, days, countdownContainer);
    update_sub_counter(2, hours, countdownContainer);
    update_sub_counter(3, minutes, countdownContainer);
    update_sub_counter(4, seconds, countdownContainer);
}

/**
 * Updates the sub counter (e.g. days, hours, minutes and hours of the countdown timer)
 * @param boxNumber The number from (1 to 4) that represents which box to change, the first box is days, the last box is seconds.
 * @param newContent Is the new value to put in the box.
 * @param countdownContainer is the countdown container
 */
function update_sub_counter(boxNumber, newContent, countdownContainer){
    let index = (boxNumber-1)*2+1;

    let node = countdownContainer.childNodes[index];
    let currentContent = node.childNodes[1].innerText;
    if(currentContent.toString() !== newContent.toString()){
        rotationValue[boxNumber-1] = rotationValue[boxNumber - 1] + 1;
        console.log(rotationValue[boxNumber-1])

        node.style.transform = "rotate3d(1,0,0,"+rotationValue[boxNumber-1]+"turn)";
    }
    node.childNodes[1].innerText = newContent;

}
async function get_due_time( url) {
    const request = new FetchRequest('get', url)
    let response = await request.perform()
    if(response.ok){
        try {

            return new Date(Date.parse((await response.json).due))
        }catch(err){
            return err
        }
    }
}

document.addEventListener("turbo:load", () => {
  get_and_set_countdown_timer()
})