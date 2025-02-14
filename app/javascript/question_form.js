document.getElementById("add-option").addEventListener("click", function () {
    const optionsFields = document.getElementById("options-fields");
    const optionIndex = optionsFields.children.length; // Track the index based on current count

    const newOption = document.createElement("div");
    newOption.className = "option-set";
    newOption.innerHTML = `
    <div class="input-group mb-3">
      <span class="input-group-text">Option</span>
      <input type="text" name="question[options][${optionIndex}][option_text]" class="form-control me-2" required>
      <span class="me-2">Correct?</span>
      <input type="checkbox" name="question[options][${optionIndex}][is_correct]" class="form-check-input">
      <button type="button" class="btn btn-danger btn-sm ms-3 remove-option">Remove</button>
    </div>
  `;
    optionsFields.appendChild(newOption);
});

document.addEventListener("click", function (event) {
    if (event.target.classList.contains("remove-option")) {
        event.target.closest(".option-set").remove();
    }
});
