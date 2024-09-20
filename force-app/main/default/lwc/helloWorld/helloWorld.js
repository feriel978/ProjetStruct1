import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Enter UserName please';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}