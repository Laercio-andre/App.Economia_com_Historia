// src/main/java/com/economiangola/dto/request/CriarCategoriaRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CriarCategoriaRequest {

    @NotBlank(message = "O nome da categoria é obrigatório")
    private String nome;

    private String descricao;
    private String iconeUrl;
    private Long categoriaPaiId;
    private Integer ordem;
}
