// src/main/java/com/economiangola/dto/request/ActualizarConteudoRequest.java
package com.economiangola.dto.request;

import com.economiangola.domain.enums.StatusConteudo;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActualizarConteudoRequest {

    private String titulo;
    private String resumo;
    private String corpo;
    private Long categoriaId;
    private StatusConteudo status;
    private List<CriarConteudoRequest.MidiaDto> midias;
    private List<String> tags;
}
