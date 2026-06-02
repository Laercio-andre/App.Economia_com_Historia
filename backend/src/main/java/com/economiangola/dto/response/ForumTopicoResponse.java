// src/main/java/com/economiangola/dto/response/ForumTopicoResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ForumTopicoResponse {

    private Long id;
    private String titulo;
    private String slug;
    private String corpo;
    private ConteudoResponse.AutorResumo autor;
    private ConteudoResponse.CategoriaResumo categoria;
    private Boolean fixado;
    private Boolean fechado;
    private Long visualizacoes;
    private long totalRespostas;
    private Instant criadoEm;
    private Instant actualizadoEm;
}
