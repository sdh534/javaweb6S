class CustomRenderer {
  constructor(props) {
    const el = document.createElement('img');
    el.src = '';
		el.height = 80;
    this.el = el;
    this.el.src = "../../resources/data/product/"+String(props.value);
  }

  getElement() {
    return this.el;
  }
}

class CustomSelectEditorSellStatus {
  constructor(props) {
    const el = document.createElement('select');

    el.value = String(props.value);

		var firstval = [{label: '노출안함', value: 0},{label: '정상판매', value: 1},{label: '임시품절', value: 2}];
		
		let fn = firstval.length;  
		let fitem;  
		for(let i=0; i < fn; i++){  
			fitem = firstval[i];  el.append(new Option(fitem.label, fitem.value));    
		}  
		this.el = el;  
  }

  getElement() {
    return this.el;
  }

  getValue() {
    return Number(this.el[this.el.selectedIndex].value);
  }

  mounted() {
    //this.el.select();
  }
}


$(document).ready(function() {
	"use strict";




	// Spinner
	var spinner = function() {
		setTimeout(function() {
			if ($('#spinner').length > 0) {
				$('#spinner').removeClass('show');
			}
		}, 1);
	};
	spinner();


	// Back to top button
	$(window).scroll(function() {
		if ($(this).scrollTop() > 300) {
			$('.back-to-top').fadeIn('slow');
		} else {
			$('.back-to-top').fadeOut('slow');
		}
	});
	$('.back-to-top').click(function() {
		$('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
		return false;
	});


	// Sidebar Toggler
	$('.sidebar-toggler').click(function() {
		$('.sidebar, .content').toggleClass("open");
		return false;
	});


	// Progress Bar
	$('.pg-bar').waypoint(function() {
		$('.progress .progress-bar').each(function() {
			$(this).css("width", $(this).attr("aria-valuenow") + '%');
		});
	}, { offset: '80%' });


	// Calender
	$('#calender').datetimepicker({
		inline: true,
		format: 'L'
	});


	// Testimonials carousel
	$(".testimonial-carousel").owlCarousel({
		autoplay: true,
		smartSpeed: 1000,
		items: 1,
		dots: true,
		loop: true,
		nav: false
	});


});

