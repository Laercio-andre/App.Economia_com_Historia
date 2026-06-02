// src/main/java/com/economiangola/dto/response/CategoriaResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoriaResponse {

    private Long id;
    private String nome;
    private String slug;
    private String descricao;
    private String iconeUrl;
    private Integer ordem;
    private List<CategoriaResponse> subcategorias;
}
