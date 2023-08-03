

//파일 업로드 시 사용할 배열
var uploadFiles = [];
var size = 0;
//드래그 앤 드롭 업로드 구현 
var p_image = document.querySelector("p_image");
var drop = document.querySelector("#drop-file");

$(document).ready(function() {
	let p_image_upload = document.querySelector('#p_image_upload');
  let drop_file = document.querySelector('#drop-file');
	drop_file.addEventListener('click', () => p_image_upload.click());

	$("#p_image_upload").bind("change", function(e) {
		for (let i = 0; i < e.target.files.length; i++) {
			console.log(e.target.files[i]);
			size = uploadFiles.push(e.target.files[i]); //업로드 목록에 추가하고 idx 번호를 반환
			thumbNailPreview(e.target.files[i], size);
		}
		$(".message").html("아래의 목록에서 썸네일 이미지를<br/> 클릭해서 선택해주세요.");

	});
	$("#drop-file").bind("dragover", function(e) {
		e.preventDefault();
		$(".upload-box .drag-file").css("border-color", "#DC3545");
	});
	$("#drop-file").bind("dragleave", function(e) {
		e.preventDefault();
		$(".upload-box .drag-file").css("border-color", "#dbdbdb");
	});
	$("#drop-file").bind("drop", function(e) {
		e.preventDefault();
		console.log("drop(드롭...)");
		var data = e.originalEvent.dataTransfer.files; //드래그 & 드랍 항목을 파일로 변환
		for (let i = 0; i < data.length; i++) {
			let file = data[i]; //배열이므로 하나씩 받아와서
			//push : 배열의 끝에 하나 이상의 요소 추가하고, 배열의 새로운 길이를 반환(새로 추가할때마다 idx가 1씩 증가할 수 있도록)
			//즉 idx는 1부터 시작함 
			size = uploadFiles.push(file, size - 1); //업로드 목록에 추가하고 idx 번호를 반환
			thumbNailPreview(file, size);
		}
		console.log(data);
	});

});

function updateAllMessageForms() {
	for (instance in CKEDITOR.instances) {
		CKEDITOR.instances[instance].updateElement();
	}
}

function thumbNailPreview(input, idx) {
	console.log(idx);
	var reader = new FileReader;
	reader.fileName = input.name;
	reader.onload = function(e) {
		
		//들어올때마다 div 요소로 하나씩 추가해준다...
		$("#imagesPreview").append(
			'<div class="previewImage" id="preview'+idx+'">'
			+'<div class="previewDelete" onclick="previewDelete('+idx+')"><i class="fas fa-lg fa-times"></i></div>'
			+'<input type="radio" class="noRadio" name="p_thumbnailIdx" value="'+e.target.fileName+'" id="thumbnail'+idx+'"><label class="thumbnailLabel" id="thumbnailLabel'+idx+'" for="thumbnail'+idx+'" onclick="thumbnailSelect(\''+e.target.result+'\')">'
			+'<img class="previewImages" src="' + e.target.result + '" id="previewImage' + idx + '">'
			+'</label>'
			+'</div>'
		);
		
	}
	reader.readAsDataURL(input);
}


function previewDelete(idx){
	console.log(typeof(idx));
	uploadFiles.splice(idx, 1); //배열의 인덱스값으로 파일을 삭제한다
	$("#preview"+idx).remove();
}
