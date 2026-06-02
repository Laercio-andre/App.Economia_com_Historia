// src/main/java/com/economiangola/domain/entity/Permissao.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "permissoes")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Permissao extends BaseEntity {

    @Column(name = "nome", nullable = false, unique = true, length = 100)
    private String nome;

    @Column(name = "descricao", length = 255)
    private String descricao;
}
