function searchControl()
{
	jQuery('#conteudo-baixo .caixa .modos').remove(); //Remove os modos de Visualização

	var div = jQuery('#conteudo-baixo .caixa');
	var topSearchDiv = jQuery('#searchDiv');

	if(div && topSearchDiv)
	{
		topSearchDiv.html(div.html());
		jQuery('#conteudo-baixo .caixa .resultados-ordenar').remove();
		jQuery('#conteudo-baixo .caixa .resultados-pagina').remove();
	}
}

function removeSeculos(){
	jQuery('#lista-resultados .alfabeto span').each(function(){
		if(this.innerText == 'Century')
			this.parentNode.innerHTML = '';
	});
}

function audioItensPipe(){
	var lastTop = null;
	jQuery('.itemAudio').each(function(index){
		var top = $(this).position().top;
		
		if(index != 0)
		{
			if(!lastTop || lastTop == top)
				//$(this).before('<li class="item itemAudio">|</li>');
				$(this).css('border-left', 'solid 1px');
		}

		lastTop = top;
	});
}
