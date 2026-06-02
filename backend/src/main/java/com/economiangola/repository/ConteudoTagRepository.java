// src/main/java/com/economiangola/repository/ConteudoTagRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ConteudoTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConteudoTagRepository extends JpaRepository<ConteudoTag, Long> {

    List<ConteudoTag> findByConteudoId(Long conteudoId);

    void deleteByConteudoId(Long conteudoId);
}
