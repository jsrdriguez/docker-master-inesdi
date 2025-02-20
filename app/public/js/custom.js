const input_file = document.getElementById('image-file');
const input_label = document.getElementById('imageLabel')
   
const convert_to_base64 = file => new Promise((response) => {
    const file_reader = new FileReader();
    file_reader.readAsDataURL(file);
    file_reader.onload = () => response(file_reader.result);
});
   
input_file.addEventListener('change', async function(){
    input_label.style.paddingBottom = `60%`;
    const file = document.querySelector('#image-file').files;
    const my_image = await convert_to_base64(file[0]);
    
    input_label.style.backgroundImage =`url(${my_image})`
    
    input_label.innerHTML = ''
})

