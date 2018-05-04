const tut = document.getElementById("tut-card");

tut.addEventListener("click", (event) => {
  event.currentTarget.classList.toggle("wobble");
  console.log(event);
  console.log(event.currentTarget);
});
